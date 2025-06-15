import RxSwift
import RxCocoa

final class ShowEventsViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let itemSelected: Observable<EventCellViewModel>
    }
    
    struct Output {
        let title: Driver<String>
        let cells: Driver<[EventCellViewModel]>
        let showError: Signal<SingleButtonAlert>
    }
    
    let eventAPI: EventAPIProtocol
    let router: ShowEventsRoutingLogic
    
    let cells = BehaviorRelay<[EventCellViewModel]>(value: [])
    let onShowError = PublishRelay<SingleButtonAlert>()
    let disposeBag = DisposeBag()
    
    init(eventAPI: EventAPIProtocol, router: ShowEventsRoutingLogic) {
        self.eventAPI = eventAPI
        self.router = router
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .flatMap { [eventAPI] in
                eventAPI.fetchEvents()
            }
            .subscribe(
                onNext: { [weak self] in
                    self?.cells.accept($0)
                },
                onError: { [weak self] _ in
                    let alert = SingleButtonAlert(
                        title: "Erro Na Busca dos Dados",
                        message: "Tente novamente",
                        action: AlertAction(
                            buttonTitle: "OK"
                        )
                    )
                    self?.onShowError.accept(alert)
                }
            )
            .disposed(by: disposeBag)
        
        input.itemSelected
            .subscribe(onNext: { [weak self] value in
                self?.router.routeToDetail(value)
            })
            .disposed(by: disposeBag)
        
        return .init(
            title: .just("Lista de Eventos"),
            cells: cells.asDriver(),
            showError: onShowError.asSignal()
        )
    }
}

extension EventAPIProtocol {
    func fetchEvents() -> Single<[Event]> {
        Single.create { [weak self] single in
            self?.fetchEvents { result in
                switch result {
                case .success(let events):
                    single(.success(events))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create(with: {})
        }
    }
}
