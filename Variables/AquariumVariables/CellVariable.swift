/**
 A `Variable` representing a `Cell`, whose domain is all the possible `CellState`s.
 */

class CellVariable: Variable {
    public let row: Int
    public let col: Int
    
    public var name: String {
        "[\(row), \(col)]"
    }
    public var domain: Set<CellState> = Set(CellState.allCases)
    public var assignment: CellState?
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
