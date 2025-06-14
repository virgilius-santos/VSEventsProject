import Foundation
@testable import VSEventsProject

extension SingleButtonAlert {
    static func fixture(
        title: String = "",
        message: String? = nil,
        action: AlertAction = .fixture()
    ) -> Self {
        .init(title: title, message: message, action: action)
    }
}

extension AlertAction {
    static func fixture(
        buttonTitle: String = ""
    ) -> Self {
        .init(buttonTitle: buttonTitle)
    }
}
