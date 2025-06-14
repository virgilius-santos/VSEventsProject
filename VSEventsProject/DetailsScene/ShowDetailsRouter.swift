import UIKit

protocol ShowDetailsRoutingLogic {
    func sharing()
    func checkIn()
}

final class ShowDetailsRouter {
    weak var viewController: ShowDetailsViewController?
}

extension ShowDetailsRouter: ShowDetailsRoutingLogic {
    func sharing() {
        let sharingVC = SharingController(viewController: viewController)
        viewController?.present(sharingVC.activityVC, animated: true)
    }

    func checkIn() {
        let userController = viewController!.userController
        viewController?.present(userController.alert, animated: true, completion: nil)
    }
}
