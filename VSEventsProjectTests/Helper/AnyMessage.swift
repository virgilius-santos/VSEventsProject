import Foundation
import Nimble

final class AnyMessage: Equatable, CustomStringConvertible {
    static func == (lhs: AnyMessage, rhs: AnyMessage) -> Bool {
        lhs.parameters == rhs.parameters
    }
    
    var description: String {
        if parameters.isEmpty {
            return ""
        } else {
            let params = parameters.map { "\($0.base)" }.joined(separator: ", ")
            return params
        }
    }
    
    private(set) var parameters: [AnyEquatable]

    init(parameters: [AnyEquatable] = []) {
        self.parameters = parameters
    }
    
    func appendLast(of array: [any Equatable]) {
        guard let last = array.last else { return }
        parameters.append(.init(last))
    }
    
    func clearMessages() {
        parameters = []
    }
}

func equal(_ expectedValue: [any Equatable]) -> Nimble.Predicate<AnyMessage> {
    equal(AnyMessage(parameters: expectedValue.map({ .init($0) })))
}
