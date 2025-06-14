import UIKit
import RxCocoa

protocol SingleButtonDialogPresenter {
    func presentSingleButtonDialog(alert: SingleButtonAlert, primaryAction: (() -> Void)?)
}

extension SingleButtonDialogPresenter {
    func presentSingleButtonDialog(alert: SingleButtonAlert) {
        presentSingleButtonDialog(alert: alert, primaryAction: nil)
    }
}

extension SingleButtonDialogPresenter where Self: UIViewController {
    var alertMessage: Binder<SingleButtonAlert> {
        .init(self) { controller, alert in
            controller.presentSingleButtonDialog(alert: alert)
        }
    }
    
    func presentSingleButtonDialog(
        alert: SingleButtonAlert,
        primaryAction: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: alert.action.buttonTitle,
                style: .default,
                handler: { _ in primaryAction?() }
            )
        )
        self.present(alertController, animated: true, completion: nil)
    }
}
