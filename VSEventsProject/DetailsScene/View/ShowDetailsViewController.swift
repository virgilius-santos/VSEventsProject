import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxMapKit
import AlamofireImage
import MapKit

protocol ShowDetailsDisplayLogic: class {
    var viewModel: DetailViewModel { get }
}

final class ShowDetailsViewController: UIViewController, ShowDetailsDisplayLogic, SingleButtonDialogPresenter {

    var interactor: ShowDetailsBusinessLogic?

    var router: ShowDetailsRoutingLogic?

    var viewModel = DetailViewModel()

    var disposeBag = DisposeBag()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupCollectionView()
        setupButtons()
        interactor?.fetchDetail()
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
        viewModel
            .eventDetail
            .map(\.title)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .event
            .map(\.imageUrl)
            .bind(to: eventPoster.rx.imageLoader)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map(\.priceValue)
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map(\.description)
            .bind(to: descriptionTextView.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map(\.dateString)
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map(\.region)
            .bind(to: mapView.rx.region)
            .disposed(by: disposeBag)

        viewModel
            .eventDetail
            .map(\.annotations)
            .bind(to: mapView.rx.annotationsToShowToAnimate)
            .disposed(by: disposeBag)

        viewModel.onShowError
            .bind(to: rx.alertMessage)
            .disposed(by: disposeBag)

    }

    func setupCollectionView() {
        let nib = UINib(nibName: PersonCollectionViewCell.cellIdentifier, bundle: nil)
        participantsCollectionView.register(nib, forCellWithReuseIdentifier: PersonCollectionViewCell.cellIdentifier)
        viewModel
            .eventCells
            .bind(to: participantsCollectionView.rx.items(
                cellIdentifier: PersonCollectionViewCell.cellIdentifier,
                cellType: PersonCollectionViewCell.self
            )) { (_, element, cell) in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)

    }

    func setupButtons() {
        shareButton
            .rx
            .tap
            .withLatestFrom(rx.shareData)
            .bind(to: rx.routeToShare)
            .disposed(by: disposeBag)

        checkInButton.rx.tap
            .bind(to: rx.routeToCheckIn)
            .disposed(by: disposeBag)
    }

    func routeChecking() {
        router?.checkIn { [weak self] userInfo in
            self?.interactor?.postCheckIn(userInfo: userInfo)
        }
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
    var routeToShare: Binder<ShowDetailsShareData> {
        .init(base) { controller, shareData in
            controller.router?.sharing(shareData: shareData)
        }
    }
    
    var shareData: Observable<ShowDetailsShareData> {
        .just(base.shareData)
    }
    
    var routeToCheckIn: Binder<Void> {
        .init(base) { controller, _ in
            controller.router?.checkIn { [weak controller] userInfo in
                controller?.interactor?.postCheckIn(userInfo: userInfo)
            }
        }
    }
}
