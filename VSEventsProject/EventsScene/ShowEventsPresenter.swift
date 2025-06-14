
protocol ShowEventsPresentationLogic {
    func displayEvents(result: Swift.Result<[Event], SingleButtonAlert>)
}

final class ShowEventsPresenter {
    private(set) weak var viewController: ShowEventsDisplayLogic?
    
    init(viewController: ShowEventsDisplayLogic? = nil) {
        self.viewController = viewController
    }
}

extension ShowEventsPresenter: ShowEventsPresentationLogic {
    func displayEvents(result: Swift.Result<[Event], SingleButtonAlert>) {
        viewController?.title = "Lista de Eventos"
        switch result {
        case .success(let evts):
            viewController?.viewModel.cells.accept(evts)
        case .failure(let err):
            viewController?.viewModel.onShowError.on(.next(err))
        }
    }
}
