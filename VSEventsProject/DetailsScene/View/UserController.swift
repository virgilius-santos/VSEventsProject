import UIKit

final class UserController {
    var alert: UIAlertController

    var completion: (((String, String)?) -> Void)?

    init() {
        alert = UIAlertController(
            title: "Check In",
            message: "Entre com seus dados",
            preferredStyle: .alert
        )

        alert.addTextField { (textField) in
            textField.placeholder = "Digite seu nome"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Digite seu e-mail"
            textField.keyboardType = .emailAddress
        }

        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { [weak alert, weak self] (_) in
            guard let txtFlds = alert?.textFields, txtFlds.count == 2 else {
                self?.completion?(nil)
                return
            }
            let name = txtFlds[0].text ?? ""
            let email = txtFlds[1].text ?? ""
            self?.completion?((name, email))
        }

        alert.addAction(okAction)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.completion?(nil)
        }))
    }
}
