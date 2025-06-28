import UIKit
import RxSwift
import RxSwiftExt
import RxCocoa

final class ShowEventsViewController: UIViewController, SingleButtonDialogPresenter {
    let viewModel: ShowEventsViewModel
    let disposeBag = DisposeBag()

    // MARK: - Init
    
    init(viewModel: ShowEventsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil) // 👈 Não usa mais Storyboard nem XIB
        //let nibName = String(describing: ShowEventsViewController.self)
        //super.init(nibName: nibName, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = UIRefreshControl()
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando...")
        return refreshControl
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .darkGray
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        //Registro da célula
        //tableView.register(UINib(nibName: EventTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        tableView.refreshControl =  refreshControl
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
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

//MARK: - Custom Binder

extension Reactive where Base: ShowEventsViewController {
    var isLoading: Binder<Bool> {
        Binder(base) { base, isLoading in
            isLoading ? base.activityIndicator.startAnimating() : base.activityIndicator.stopAnimating()
        }
        /*
        Binder(base) { base, isLoading in
        //.init(base.activityIndicator) { activityIndicator, isLoading in
            if isLoading {
                base.activityIndicator.startAnimating()
            } else {
                base.activityIndicator.stopAnimating()
            }
        }*/
    }
}
