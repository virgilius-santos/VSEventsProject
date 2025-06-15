import UIKit

protocol ShowEventsRoutingLogic {
    func routeToDetail(_ viewModel: EventCellViewModel)
}

final class ShowEventsRouter {
    weak var viewController: UIViewController?

    // MARK: Navigation

    func navigateToDetails(source: UIViewController?, destination: UIViewController) {
        source?.show(destination, sender: nil)
    }
}

extension ShowEventsRouter: ShowEventsRoutingLogic {
    func routeToDetail(_ viewModel: EventCellViewModel) {
        let detailsConf = ShowDetailsConfigurator(eventItem: viewModel.eventItem)
        let detailVC = detailsConf.make()
        navigateToDetails(source: viewController, destination: detailVC)
    }
}
