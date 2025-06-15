import RxSwift
import RxCocoa

final class ShowDetailsViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
//        let refresh: Observable<Void>
        let userInputs: Observable<Void>
        let sharedData: Observable<ShowDetailsShareData>
    }
    
    struct Output {
        let eventDetail: Signal<DetailInfo>
        let peopleCells: Driver<[PersonCellViewModel]>
        let showMessage: Signal<SingleButtonAlert>
        let showError: Signal<SingleButtonAlert>
//        let isLoading: Driver<Bool>
//        let isRefreshing: Signal<Bool>
    }
    
    let detailAPI: ShowDetailsAPIProtocol
    let router: ShowDetailsRoutingLogic
    let event: Event
    
    private let eventDetailSubject = PublishRelay<DetailInfo>()
    private let peopleCellSubject = BehaviorRelay<[PersonCellViewModel]>(value: [])
//    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
//    private let isRefreshingSubject = PublishRelay<Bool>()
    private let showMessageSubject = PublishRelay<SingleButtonAlert>()
    private let showErrorSubject = PublishRelay<SingleButtonAlert>()
    
    private let disposeBag = DisposeBag()
    
    init(
        detailAPI: ShowDetailsAPIProtocol,
        router: ShowDetailsRoutingLogic,
        event: Event
    ) {
        self.detailAPI = detailAPI
        self.router = router
        self.event = event
    }
    
    func transform(input: Input) -> Output {
        setupUserInputsStream(input.userInputs)
        setupSharedData(input.sharedData)
        fetchEventDetail(input)
        return Output(
            eventDetail: eventDetailSubject.asSignal(),
            peopleCells: peopleCellSubject.asDriver(),
            showMessage: showMessageSubject.asSignal(),
            showError: showErrorSubject.asSignal()
//            isLoading: isLoadingSubject.asDriver(),
//            isRefreshing: isRefreshingSubject.asSignal()
        )
    }
    
    func setupUserInputsStream(_ userInputs: Observable<Void>) {
        let userResultStream = userInputs
            .flatMapLatest { [router] _ in
                Single.create { sn in
                    router.checkIn { input in
                        sn(.success(input))
                    }
                    return Disposables.create()
                }
            }
            .flatMapLatest { [detailAPI, event] in
                detailAPI.validateUserInput($0, eventModel: event)
            }
            .share()
        
        validateUserInput(userResultStream)
        performCheckIn(userResultStream)
    }
    
    func setupSharedData(_ sharedData: Observable<ShowDetailsShareData>) {
        sharedData
            .subscribe(onNext: { [weak self] shareData in
                self?.router.sharing(shareData: shareData)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - fetchEventDetail

private extension ShowDetailsViewModel {
    func fetchEventDetail(_ input: Input) {
        input.viewDidLoad
            .flatMapLatest { [detailAPI, /*isLoadingSubject,*/ event] in
//                isLoadingSubject.accept(true)
                return detailAPI.fetchEventDetail(for: event)
            }
            .subscribe(onNext: { [weak self] in
                self?.handleEventResult($0)
//                self?.isLoadingSubject.accept(false)
            })
            .disposed(by: disposeBag)
        
//        input.refresh
//            .flatMapLatest { [detailAPI, isRefreshingSubject, event] in
//                isRefreshingSubject.accept(true)
//                return detailAPI.fetchEventDetail(for: event)
//            }
//            .subscribe(onNext: { [weak self] in
//                self?.handleEventResult($0)
//                self?.isRefreshingSubject.accept(false)
//            })
//            .disposed(by: disposeBag)
    }
    
    func handleEventResult(_ result: Result<Event, Error>) {
        switch result {
        case .success(let detail):
            eventDetailSubject.accept(detail)
            peopleCellSubject.accept(detail.people)
        case .failure:
            let alert = SingleButtonAlert(
                title: "Detalhes",
                message: "Tente Novamente",
                action: AlertAction(buttonTitle: "OK")
            )
            showErrorSubject.accept(alert)
        }
    }
}

private extension ShowDetailsAPIProtocol {
    func fetchEventDetail(for eventModel: Event) -> Single<Result<Event, Error>> {
        Single.create { [weak self] single in
            self?.fetchEvent(eventModel) { result in
                single(.success(result))
            }
            return Disposables.create(with: {})
        }
    }
}

// MARK: - validateUserInput

private extension ShowDetailsViewModel {
    func validateUserInput(_ userResultStream: Observable<Result<User, SingleButtonAlert>>) {
        userResultStream
            .compactMap { result -> SingleButtonAlert? in
                if case .failure(let alert) = result {
                    return alert
                }
                return nil
            }
            .subscribe(onNext: { [showErrorSubject] in
                showErrorSubject.accept($0)
            })
            .disposed(by: disposeBag)
    }
}

private extension ShowDetailsAPIProtocol {
    func validateUserInput(_ userInput: UserInputTexts, eventModel: Event) -> Single<Result<User, SingleButtonAlert>> {
        Single.create { single in
            guard userInput.email.match(.email) else {
                let alert = SingleButtonAlert(
                    title: "Check In",
                    message: "email no formato invalido, tente novamente.",
                    action: AlertAction(buttonTitle: "OK")
                )
                single(.success(.failure(alert)))
                return Disposables.create(with: {})
            }
            
            let user = User(name: userInput.name, email: userInput.email, eventId: eventModel.id)
            single(.success(.success(user)))
            return Disposables.create(with: {})
        }
    }
}

// MARK: - performCheckIn

private extension ShowDetailsViewModel {
    func performCheckIn(_ userResultStream: Observable<Result<User, SingleButtonAlert>>) {
        userResultStream
            .compactMap { result -> User? in
                if case .success(let user) = result {
                    return user
                }
                return nil
            }
            .flatMapLatest { [detailAPI] in
                detailAPI.performCheckIn(for: $0)
            }
            .subscribe(onNext: { [weak self] in
                self?.handleCheckInResult($0)
            })
            .disposed(by: disposeBag)
    }
    
    func handleCheckInResult(_ result: Result<CheckIn, Error>) {
        if case .success(let model) = result, model.code == "200" {
            let alert = checkInMessage("Sucesso!")
            showMessageSubject.accept(alert)
        } else {
            let alert = checkInMessage("Houve uma falha, tente novamente mais tarte.")
            showErrorSubject.accept(alert)
        }
    }
    
    func checkInMessage(_ message: String) -> SingleButtonAlert {
        SingleButtonAlert(
            title: "Check In",
            message: message,
            action: AlertAction(buttonTitle: "OK")
        )
    }
}

extension ShowDetailsAPIProtocol {
    func performCheckIn(for user: User) -> Single<Result<CheckIn, Error>> {
        Single.create { [weak self] single in
            self?.checkIn(user: user) { result in
                single(.success(result))
            }
            return Disposables.create(with: {})
        }
    }
}
