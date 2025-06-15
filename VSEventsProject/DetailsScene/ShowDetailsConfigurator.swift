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
        let detailAPI = ShowDetailsService()
        let router = ShowDetailsRouter()
        let viewModel = ShowDetailsViewModelV2(
            detailAPI: detailAPI,
            router: router,
            event: eventItem
        )
        viewController.viewModel = viewModel
        router.viewController = viewController
        return viewController
    }
}
