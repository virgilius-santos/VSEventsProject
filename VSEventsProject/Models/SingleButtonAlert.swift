import UIKit

struct AlertAction: Equatable {
    let buttonTitle: String
//    let handler: (() -> Void)?
}

struct SingleButtonAlert: Equatable {
    let title: String
    let message: String?
    let action: AlertAction
}
