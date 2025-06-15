import Foundation
import UIKit

final class ShowDetailsConfigurator: ShowDetailsFactoryProtocol {
    typealias Dependencies = HasApi
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func make(eventItem: Event) -> UIViewController {
        let detailAPI = ShowDetailsService(
            api: dependencies.api
        )
        let router = ShowDetailsRouter()
        let viewModel = ShowDetailsViewModel(
            detailAPI: detailAPI,
            router: router,
            event: eventItem
        )
        let viewController = ShowDetailsViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
