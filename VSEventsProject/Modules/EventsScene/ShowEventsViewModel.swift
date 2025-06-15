import RxSwift
import RxCocoa

final class ShowEventsViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let refresh: Observable<Void>
        let itemSelected: Observable<EventCellViewModel>
    }
    
    struct Output {
        let title: Driver<String>
        let cells: Driver<[EventCellViewModel]>
        let showError: Signal<SingleButtonAlert>
        let isLoading: Driver<Bool>
        let isRefreshing: Signal<Bool>
    }
    
    let eventAPI: EventAPIProtocol
    let router: ShowEventsRoutingLogic
    
    let cells = BehaviorRelay<[EventCellViewModel]>(value: [])
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = PublishRelay<Bool>()
    let onShowError = PublishRelay<SingleButtonAlert>()
    let disposeBag = DisposeBag()
    
    init(eventAPI: EventAPIProtocol, router: ShowEventsRoutingLogic) {
        self.eventAPI = eventAPI
        self.router = router
    }
    
    func transform(input: Input) -> Output {
       input.viewDidLoad
            .flatMapLatest { [eventAPI, loading] in
                loading.accept(true)
                return eventAPI.fetchEvents()
            }
            .subscribe(
                onNext: { [weak self] in
                    guard let self else { return }
                    self.handleResult($0)
                    loading.accept(false)
                }
            )
            .disposed(by: disposeBag)
        
        input.refresh
            .flatMapLatest { [eventAPI, refreshing] in
                refreshing.accept(true)
                return eventAPI.fetchEvents()
            }
            .subscribe(
                onNext: { [weak self] in
                    guard let self else { return }
                    self.handleResult($0)
                    refreshing.accept(false)
                }
            )
            .disposed(by: disposeBag)
        
        input.itemSelected
            .subscribe(onNext: { [weak self] value in
                self?.router.routeToDetail(value.eventItem)
            })
            .disposed(by: disposeBag)
        
        return .init(
            title: .just("Lista de Eventos"),
            cells: cells.asDriver(),
            showError: onShowError.asSignal(),
            isLoading: loading.asDriver(),
            isRefreshing: refreshing.asSignal()
        )
    }
    
    func handleResult(_ result: Result<[Event], Error>) {
        switch result {
            case .success(let events):
            cells.accept(events.map(EventCellViewModel.init))
        case .failure:
            let alert = SingleButtonAlert(
                title: "Erro Na Busca dos Dados",
                message: "Tente novamente",
                action: AlertAction(
                    buttonTitle: "OK"
                )
            )
            onShowError.accept(alert)
        }
    }
}

extension EventAPIProtocol {
    func fetchEvents() -> Single<Result<[Event], Error>> {
        Single.create { [weak self] single in
            self?.fetchEvents { result in
                single(.success(result))
            }
            return Disposables.create(with: {})
        }
    }
}
