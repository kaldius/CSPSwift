public enum CellState: Value, CaseIterable {
    case water, air
}
extension CellState: Copyable {
    public func copy() -> CellState {
        self
    }
}

extension [CellState]: Value {}
