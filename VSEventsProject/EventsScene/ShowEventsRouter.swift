import UIKit

protocol ShowEventsRoutingLogic {
    func routeToDetail(_ viewModel: EventCellViewModel)
}

final class ShowEventsRouter {
    weak var viewController: ShowEventsViewController?

    // MARK: Navigation

    func navigateToDetails(source: ShowEventsViewController?, destination: UIViewController) {
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
