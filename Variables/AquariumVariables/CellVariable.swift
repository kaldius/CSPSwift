/**
 A `Variable` representing a `Cell`, whose domain is all the possible `CellState`s.
 */

class CellVariable: Variable {
    public let row: Int
    public let col: Int
    
    public var name: String {
        "[\(row), \(col)]"
    }
    public var internalDomain: Set<CellState>
    public var domainUndoStack: Stack<Set<CellState>>
    public var internalAssignment: CellState?
    public var constraints: [any Constraint]
    
    public var isAir: Bool {
        assignment == .air
    }
    
    public var isWater: Bool {
        assignment == .water
    }
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.internalDomain = Set(CellState.allCases)
        self.domainUndoStack = Stack()
        self.internalAssignment = nil
        self.constraints = []
    }
}
