import UIKit
import RxSwift
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


extension Reactive where Base: UIViewController & SingleButtonDialogPresenter {
    var alertMessage: Binder<SingleButtonAlert> {
        .init(base) { controller, alert in
            controller.presentSingleButtonDialog(alert: alert)
        }
    }
}
