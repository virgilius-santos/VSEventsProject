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

    func bindViewModel() {
        guard let viewModel else { return }
        let refresh = PublishRelay<Void>()
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: .just(()),
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
                refresh.accept(())
            })
            .disposed(by: disposeBag)
        
        output.isRefreshing
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).asObservable()
            .subscribe(onNext: {
                refresh.accept(())
            })
            .disposed(by: disposeBag)
    }
}
