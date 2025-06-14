import UIKit

protocol ShowDetailsRoutingLogic {
    func sharing(shareData: ShowDetailsShareData)
    func checkIn(onOK: @escaping (UserInputTexts) -> Void)
}

final class ShowDetailsRouter {
    weak var viewController: ShowDetailsViewController?
    let userControllerFactory = UserControllerFactory()
    let sharingControllerFactory = SharingControllerFactory()
}

extension ShowDetailsRouter: ShowDetailsRoutingLogic {
    func sharing(shareData: ShowDetailsShareData) {
        let sharingVC = sharingControllerFactory.make(shareData: shareData)
        sharingVC.popoverPresentationController?.sourceView = viewController?.view
        viewController?.present(sharingVC, animated: true)
    }

    func checkIn(onOK: @escaping (UserInputTexts) -> Void) {
        let userController = userControllerFactory.makeUserInputAlertController(
            onOK: onOK
        )
        viewController?.present(userController, animated: true, completion: nil)
    }
}
