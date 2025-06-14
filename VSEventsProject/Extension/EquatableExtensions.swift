// Função auxiliar para comparar valores genéricos
func areEqual<T>(_ lhs: T, _ rhs: T) -> Bool {
    guard
        let lhsEq = lhs as? any Equatable,
        let rhsEq = rhs as? any Equatable
    else {
        return false
    }
    return lhsEq.isEqual(rhsEq)
}

// Extensão para comparar qualquer Equatable
extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}
