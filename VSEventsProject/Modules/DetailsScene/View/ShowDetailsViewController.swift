import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxMapKit
import AlamofireImage
import MapKit

final class ShowDetailsViewController: UIViewController, SingleButtonDialogPresenter {
    let viewModel: ShowDetailsViewModelV2
    let disposeBag = DisposeBag()

    // MARK: View lifecycle
    
    init(viewModel: ShowDetailsViewModelV2) {
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
        bindViewModel()
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
