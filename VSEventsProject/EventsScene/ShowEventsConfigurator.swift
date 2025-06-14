import UIKit

final class ShowEventsConfigurator {

    private let nibName = String(describing: ShowEventsViewController.self)

    func make() -> UIViewController {
        let viewController = ShowEventsViewController(nibName: nibName, bundle: nil)
        let presenter = ShowEventsPresenter(viewController: viewController)
        let eventAPI = ShowEventsEventService()
        let interactor = ShowEventsInteractor(
            presenter: presenter,
            eventAPI: eventAPI
        )
        let router = ShowEventsRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        return viewController
    }
}
