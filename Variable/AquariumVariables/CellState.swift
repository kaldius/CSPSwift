public enum CellState: Value, CaseIterable {
    case water, air
}

extension [CellState]: Value {}
