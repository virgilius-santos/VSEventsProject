import UIKit

final class ShowEventsConfigurator {
    typealias Dependencies = HasShowDetailsFactoryProtocol
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func make() -> UIViewController {        
        let eventAPI = ShowEventsEventService()
        let router = ShowEventsRouter(
            dependencies: dependencies
        )
        let viewModel = ShowEventsViewModel(
            eventAPI: eventAPI,
            router: router
        )
        let viewController = ShowEventsViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
