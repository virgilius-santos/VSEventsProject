import UIKit

final class UserControllerFactory {
    func makeUserInputAlertController(
        strings: UserAlertStrings = UserAlertStrings(),
        onOK: @escaping (UserInputTexts) -> Void,
        onCancel: @escaping () -> Void = {}
    ) -> UIViewController {
        let alert = UIAlertController(
            title: strings.title,
            message: strings.message,
            preferredStyle: .alert
        )

        alert.addTextField { (textField) in
            textField.placeholder = strings.namePlaceholder
        }

        alert.addTextField { (textField) in
            textField.placeholder = strings.emailPlaceholder
            textField.keyboardType = .emailAddress
        }

        let okAction = UIAlertAction(
            title: strings.okButton,
            style: .default
        ) { [weak alert] (_) in
            guard let txtFlds = alert?.textFields, txtFlds.count == 2 else {
                return
            }
            let name = txtFlds[0].text ?? ""
            let email = txtFlds[1].text ?? ""
            onOK(UserInputTexts(name: name, email: email))
        }

        alert.addAction(okAction)

        alert.addAction(UIAlertAction(title: strings.cancelButton, style: .cancel, handler: { _ in
            onCancel()
        }))
        return alert
    }
}
