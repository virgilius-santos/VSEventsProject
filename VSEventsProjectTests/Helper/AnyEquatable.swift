import Foundation

struct AnyEquatable: Equatable {
    private let _isEqual: (Any) -> Bool
    public let base: Any

    public init<T: Equatable>(_ base: T) {
        self.base = base
        self._isEqual = { other in
            guard let otherBase = other as? T else { return false }
            return base == otherBase
        }
    }

    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs._isEqual(rhs.base)
    }
}
