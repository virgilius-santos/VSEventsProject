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
                self?.router.routeToDetail(value)
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
            cells.accept(events)
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
        return .just(.success([
            Event(
                id: "1",
                title: "Evento Teste 1",
                price: 100.0,
                latitude: -23.55,
                longitude: -46.63,
                image: URL(string: "https://via.placeholder.com/300.png/09f/fff?text=Evento1")!,
                description: "Descrição do evento teste 1.",
                date: Date(),
                people: [
                    Person(id: "p1", eventId: "1", name: "Participante 1", picture: "https://via.placeholder.com/50.png/09f/fff?text=P1")
                ],
                cupons: [
                    Cupom(id: "c1", eventId: "1", discount: 10)
                ]
            ),
            Event(
                id: "2",
                title: "Evento Teste 2",
                price: 150.0,
                latitude: -22.90,
                longitude: -43.20,
                image: URL(string: "https://via.placeholder.com/300.png/09f/fff?text=Evento2")!,
                description: "Descrição do evento teste 2.",
                date: Date().addingTimeInterval(86400),
                people: [
                    Person(id: "p2", eventId: "2", name: "Participante 2", picture: "https://via.placeholder.com/50.png/09f/fff?text=P2")
                ],
                cupons: [
                    Cupom(id: "c2", eventId: "2", discount: 15)
                ]
            )
        ]))
        .delaySubscription(.seconds(1), scheduler: MainScheduler.instance)
                    
//        Single.create { [weak self] single in
//            self?.fetchEvents { result in
//                single(.success(result))
//            }
//            return Disposables.create(with: {})
//        }
    }
}
