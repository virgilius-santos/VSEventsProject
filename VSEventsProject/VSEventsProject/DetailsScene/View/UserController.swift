//
//  UserController.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class UserController {

    var alert: UIAlertController

    var completion: (((String, String)?)->())?

    init() {
        alert = UIAlertController(title: "Check In",
                                      message: "Entre com seus dados",
                                      preferredStyle: .alert)


        alert.addTextField { (textField) in
            textField.placeholder = "Digite seu nome"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Digite seu e-mail"
            textField.keyboardType = .emailAddress
        }

        let okAction = UIAlertAction(
            title: "OK",
            style: .default) { [weak alert] (_) in

                guard let txtFlds = alert?.textFields, txtFlds.count == 2 else {

                    self.completion?(nil)
                        return
                }

                let name = txtFlds[0].text
                let email = txtFlds[1].text
                self.completion?((name!,email!))

        }

        alert.addAction(okAction)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.completion?(nil)
        }))
    }
}
