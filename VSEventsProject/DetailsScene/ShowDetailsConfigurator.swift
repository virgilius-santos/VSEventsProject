import Foundation
import UIKit

final class ShowDetailsConfigurator {
    private let nibName = String(describing: ShowDetailsViewController.self)

    let eventItem: Event

    init(eventItem: Event) {
        self.eventItem = eventItem
    }
    
    func make() -> UIViewController {
        let viewController = ShowDetailsViewController(nibName: nibName, bundle: nil)
        let presenter = ShowDetailsPresenter()
        let eventAPI = ShowDetailsService()
        let interactor = ShowDetailsInteractor(
            presenter: presenter,
            eventAPI: eventAPI,
            event: eventItem
        )
        let router = ShowDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        presenter.viewController = viewController
        router.viewController = viewController
        return viewController
    }
}
