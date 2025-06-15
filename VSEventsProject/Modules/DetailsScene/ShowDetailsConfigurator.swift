import Foundation
import UIKit

final class ShowDetailsConfigurator: ShowDetailsFactoryProtocol {
    typealias Dependencies = HasApi
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    private let nibName = String(describing: ShowDetailsViewController.self)
    
    func make(eventItem: Event) -> UIViewController {
        let viewController = ShowDetailsViewController(nibName: nibName, bundle: nil)
        let detailAPI = ShowDetailsService(
            api: dependencies.api
        )
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
