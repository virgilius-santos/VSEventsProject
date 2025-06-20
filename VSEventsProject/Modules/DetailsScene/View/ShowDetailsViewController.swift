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
    
    init(viewModel: ShowDetailsViewModel) {
        self.viewModel = viewModel
        let nibName = String(describing: ShowDetailsViewController.self)
        super.init(nibName: nibName, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bindViewModel()
        setupCollectionView()
        bindPeopleCells(mockPeople()) // para os testes
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventPoster.af_cancelImageRequest()
    }

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var eventPoster: UIImageView!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var participantsCollectionView: UICollectionView!

    @IBOutlet weak var checkInButton: UIButton!

    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var mapView: MKMapView!
    
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

