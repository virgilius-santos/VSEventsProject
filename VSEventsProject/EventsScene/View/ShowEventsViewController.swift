import UIKit
import RxSwift
import RxSwiftExt
import RxCocoa

final class ShowEventsViewController: UIViewController, SingleButtonDialogPresenter {
    var viewModel: ShowEventsViewModel?
    var disposeBag = DisposeBag()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: EventTableViewCell.cellIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
            tableView.refreshControl = refreshControl
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .systemBlue
        rc.attributedTitle = NSAttributedString(string: "Atualizando...")
        return rc
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return activityIndicator
    }()

    func bindViewModel() {
        guard let viewModel else { return }
        let refresh = PublishRelay<Void>()
        let load = BehaviorRelay(value: ())
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: load.asObservable(),
                refresh: refresh.asObservable(),
                itemSelected: tableView.rx
                    .modelSelected(EventCellViewModel.self)
                    .asObservable()
            )
        )
        output.cells
            .drive(tableView.rx.items(
                cellIdentifier: EventTableViewCell.cellIdentifier,
                cellType: EventTableViewCell.self
            )) { (_, element, cell) in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)
        
        output.showError
            .emit(to: rx.showAlertMessage {
                load.accept(())
            })
            .disposed(by: disposeBag)

        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        
        output.isRefreshing
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .asSignal()
            .emit(to: refresh)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: ShowEventsViewController {
    var isLoading: Binder<Bool> {
        .init(base.activityIndicator) { activityIndicator, isLoading in
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}
