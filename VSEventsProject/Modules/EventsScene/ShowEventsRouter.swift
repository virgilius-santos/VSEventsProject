import UIKit

protocol ShowEventsRoutingLogic {
    func routeToDetail(_ eventItem: Event)
}

final class ShowEventsRouter {
    typealias Dependencies = HasShowDetailsFactoryProtocol
    
    let dependencies: Dependencies
    
    weak var viewController: UIViewController?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Navigation

    func navigateToDetails(source: UIViewController?, destination: UIViewController) {
        source?.show(destination, sender: nil)
    }
}

extension ShowEventsRouter: ShowEventsRoutingLogic {
    func routeToDetail(_ eventItem: Event) {
        let detailVC = dependencies.showDetailsFactory.make(eventItem: eventItem)
        navigateToDetails(source: viewController, destination: detailVC)
    }
}
