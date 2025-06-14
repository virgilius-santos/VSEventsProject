import UIKit

struct AlertAction: Equatable {
    let buttonTitle: String
}

struct SingleButtonAlert: Equatable, Error {
    let title: String
    let message: String?
    let action: AlertAction
}
