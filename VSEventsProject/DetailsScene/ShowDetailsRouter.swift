import UIKit

protocol ShowDetailsRoutingLogic {
    func sharing()
    func checkIn(onOK: @escaping (UserInputTexts) -> Void)
}

final class ShowDetailsRouter {
    weak var viewController: ShowDetailsViewController?
    let userControllerFactory = UserControllerFactory()
}

extension ShowDetailsRouter: ShowDetailsRoutingLogic {
    func sharing() {
        let sharingVC = SharingController(viewController: viewController)
        viewController?.present(sharingVC.activityVC, animated: true)
    }

    func checkIn(onOK: @escaping (UserInputTexts) -> Void) {
        let userController = userControllerFactory.makeUserInputAlertController(
            onOK: onOK
        )
        viewController?.present(userController, animated: true, completion: nil)
    }
}
