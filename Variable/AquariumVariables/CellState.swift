public enum CellState: Value, CaseIterable {
    case water, air
}
extension CellState: Copyable {
    public func copy() -> CellState {
        self
    }
}

extension Array: Comparable where Element: Comparable {
    public static func < (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
        // TODO: implement
        false
    }
}

extension [CellState]: Value {}
