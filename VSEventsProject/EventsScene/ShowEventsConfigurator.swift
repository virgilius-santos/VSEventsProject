import UIKit

final class ShowEventsConfigurator {

    private let nibName = String(describing: ShowEventsViewController.self)

    func make() -> UIViewController {
        let viewController = ShowEventsViewController(nibName: nibName, bundle: nil)
        let eventAPI = ShowEventsEventService()
        let router = ShowEventsRouter()
        let viewModel = ShowEventsViewModel(
            eventAPI: eventAPI,
            router: router
        )
        viewController.viewModel = viewModel
        router.viewController = viewController
        return viewController
    }
}
