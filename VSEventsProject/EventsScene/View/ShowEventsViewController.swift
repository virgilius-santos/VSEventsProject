import UIKit
import RxSwift
import RxSwiftExt

protocol ShowEventsDisplayLogic: class {
    var title: String? { get set }
    var viewModel: EventsTableViewViewModel { get }
}

final class ShowEventsViewController: UIViewController, ShowEventsDisplayLogic, SingleButtonDialogPresenter {
    var viewModel = EventsTableViewViewModel()

    var interactor: ShowEventsBusinessLogic?
    var router: ShowEventsRoutingLogic?

    var disposeBag = DisposeBag()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupTableView()
        fetchEvents()
    }

    @IBOutlet weak var tableView: UITableView!

    func bindViewModel() {
        viewModel.eventCells
            .bind(to: tableView.rx.items(
                cellIdentifier: EventTableViewCell.cellIdentifier,
                cellType: EventTableViewCell.self
            )) { (_, element, cell) in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)

        viewModel.onShowError
            .bind(to: rx.alertMessage)
            .disposed(by: disposeBag)
    }

    func setupTableView() {
        let nib = UINib(nibName: EventTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)

        tableView.rx
            .modelSelected(EventCellViewModel.self)
            .subscribe(onNext: { [weak self] value in
                self?.router?.routeToDetail(value)
            })
            .disposed(by: disposeBag)
    }

    func fetchEvents() {
        interactor?.fetchEvents()
    }
}
