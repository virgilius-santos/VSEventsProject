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
        }
    }

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
            .emit(to: rx.showAlertMessage(completion: {
                refresh.accept(())
            }))
            .disposed(by: disposeBag)
    }
}
