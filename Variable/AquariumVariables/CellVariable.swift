/**
 A `Variable` representing a `Cell`, whose domain is all the possible `CellState`s.
 */
struct CellVariable: Variable {
    public let row: Int
    public let col: Int
    public var internalDomain: Set<CellState>
    public var internalAssignment: CellState?

    public var name: String {
        "[\(row), \(col)]"
    }

    public var isAir: Bool {
        assignment == .air
    }
    
    public var isWater: Bool {
        assignment == .water
    }

    init(row: Int,
         col: Int,
         internalDomain: Set<CellState>,
         internalAssignment: CellState?) {
        self.row = row
        self.col = col
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
    }
    
    init(row: Int, col: Int) {
        self.init(row: row,
                  col: col,
                  internalDomain: Set(CellState.allCases),
                  internalAssignment: nil)
    }
}

extension CellVariable: Copyable {
    func copy() -> Self {
        self
    }
}
