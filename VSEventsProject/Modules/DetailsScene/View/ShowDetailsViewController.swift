import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxMapKit
import AlamofireImage
import MapKit

final class ShowDetailsViewController: UIViewController, SingleButtonDialogPresenter {
    let viewModel: ShowDetailsViewModel
    let disposeBag = DisposeBag()

    // MARK: View lifecycle
    /*
    init(viewModel: ShowDetailsViewModel) {
        self.viewModel = viewModel
        let nibName = String(describing: ShowDetailsViewController.self)
        super.init(nibName: nibName, bundle: nil)
    }*/
    
    init(viewModel: ShowDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupSubviews()
        setupConstraints()
        //bindViewModel()
        setupCollectionView()
        bindPeopleCells(mockPeople()) // para os testes
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventPoster.af_cancelImageRequest()
    }
    
    private func setupSubviews() {
        [titleLabel, eventPoster, dateLabel, priceLabel,
         descriptionTextView, checkInButton, shareButton,
         participantsCollectionView, mapView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0

        eventPoster.contentMode = .scaleAspectFill
        eventPoster.clipsToBounds = true

        dateLabel.font = .systemFont(ofSize: 14)
        priceLabel.font = .systemFont(ofSize: 14)

        descriptionTextView.isEditable = false
        descriptionTextView.font = .systemFont(ofSize: 16)

        checkInButton.setTitle("Check IN", for: .normal)
        shareButton.setTitle("Share", for: .normal)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            eventPoster.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            eventPoster.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            eventPoster.widthAnchor.constraint(equalToConstant: 120),
            eventPoster.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: eventPoster.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: eventPoster.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            priceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),

            checkInButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            checkInButton.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),

            shareButton.centerYAnchor.constraint(equalTo: checkInButton.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: checkInButton.trailingAnchor, constant: 20),

            descriptionTextView.topAnchor.constraint(equalTo: eventPoster.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 80),

            participantsCollectionView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            participantsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            participantsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            participantsCollectionView.heightAnchor.constraint(equalToConstant: 400), // ajustar conforme necessário

            mapView.topAnchor.constraint(equalTo: participantsCollectionView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private let titleLabel = UILabel()
    private let eventPoster = UIImageView()
    private let dateLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let participantsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 16

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return cv
    }()
    private let checkInButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let mapView = MKMapView()

    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 16

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return cv
    }()

    func bindViewModel() {
//        let refresh = PublishRelay<Void>()
        let load = BehaviorRelay(value: ())
        let sharedData = shareButton
            .rx
            .tap
            .withLatestFrom(rx.shareData)
            .asObservable()
        
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: load.asObservable(),
//                refresh: refresh.asObservable(),
                userInputs: checkInButton.rx.tap.asObservable(),
                sharedData: sharedData
            )
        )
        
        bindEventDetails(output.eventDetail)
        bindPeopleCells(output.peopleCells)
        
        output.showError
            .emit(to: rx.showAlertMessage {
                load.accept(())
            })
            .disposed(by: disposeBag)
        
        output.showMessage
            .emit(to: rx.showAlertMessage())
            .disposed(by: disposeBag)
        
        output.peopleCells
            .drive(collectionView.rx.items(
                cellIdentifier: "PersonCollectionViewCell",
                cellType: PersonCollectionViewCell.self
            )) { _, viewModel, cell in
                cell.configure(with: viewModel as! MockPersonCellViewModel)
            }
            .disposed(by: disposeBag)

    }
    
    func bindEventDetails(_ eventDetail: Signal<any DetailInfo>) {
        eventDetail
            .map(\.title)
            .emit(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        eventDetail
            .map(\.imageUrl)
            .emit(to: eventPoster.rx.imageLoader)
            .disposed(by: disposeBag)

        eventDetail
            .map(\.priceValue)
            .emit(to: priceLabel.rx.text)
            .disposed(by: disposeBag)

        eventDetail
            .map(\.description)
            .emit(to: descriptionTextView.rx.text)
            .disposed(by: disposeBag)

        eventDetail
            .map(\.dateString)
            .emit(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        eventDetail
            .map(\.region)
            .emit(to: mapView.rx.region)
            .disposed(by: disposeBag)

        eventDetail
            .map(\.annotations)
            .emit(to: mapView.rx.annotationsToShowToAnimate)
            .disposed(by: disposeBag)
    }

    func bindPeopleCells(_ peopleCells: Driver<[any PersonCellViewModel]>) {
        let nib = UINib(nibName: PersonCollectionViewCell.cellIdentifier, bundle: nil)
        participantsCollectionView.register(nib, forCellWithReuseIdentifier: PersonCollectionViewCell.cellIdentifier)
        
        peopleCells
            .drive(participantsCollectionView.rx.items(
                cellIdentifier: PersonCollectionViewCell.cellIdentifier,
                cellType: PersonCollectionViewCell.self
            )) { (_, element, cell) in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: "PersonCollectionViewCell")
    }

}

extension ShowDetailsViewController {
    var shareData: ShowDetailsShareData {
        ShowDetailsShareData(
            title: titleLabel.text,
            price: priceLabel.text,
            date: dateLabel.text,
            poster: eventPoster.image
        )
    }
}

extension Reactive where Base: ShowDetailsViewController {
//    var routeToShare: Binder<ShowDetailsShareData> {
//        .init(base) { controller, shareData in
//            controller.router?.sharing(shareData: shareData)
//        }
//    }
//    
    var shareData: Observable<ShowDetailsShareData> {
        .just(base.shareData)
    }
//    
//    var routeToCheckIn: Binder<Void> {
//        .init(base) { controller, _ in
//            controller.router?.checkIn { [weak controller] userInfo in
//                controller?.interactor?.postCheckIn(userInfo: userInfo)
//            }
//        }
//    }
}

extension ShowDetailsViewController {
    func mockPeople() -> Driver<[any PersonCellViewModel]> {
        let mock: [MockPersonCellViewModel] = [
            .init(
                eventItem: Person(id: "1", eventId: "a", name: "Alice", picture: "https://picsum.photos/200/100?1"),
                title: "Evento de Tecnologia 1",
                imageUrl: URL(string: "https://picsum.photos/200/100?1")
            ),
            .init(
                eventItem: Person(id: "2", eventId: "b", name: "Bruno", picture: ""),
                title: "Conferência de Marketing Digital 2",
                imageUrl: nil
            ),
            .init(
                eventItem: Person(id: "3", eventId: "c", name: "Carla", picture: "https://picsum.photos/200/100?3"),
                title: "Workshop de Fotografia 3",
                imageUrl: URL(string: "https://picsum.photos/200/100?3")
            ),
            .init(
                eventItem: Person(id: "4", eventId: "d", name: "Daniela", picture: "https://picsum.photos/200/100?4"),
                title: "Festival de Música Indie 4",
                imageUrl: URL(string: "https://picsum.photos/200/100?4")
            )
        ]

        return Driver.just(mock)
    }
}

