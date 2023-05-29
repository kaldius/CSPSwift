/**
 A `Variable` representing a `Cell`, whose domain is all the possible `CellState`s.
 */
class CellVariable: Variable {
    public let row: Int
    public let col: Int
    public var internalDomain: Set<CellState>
    public var internalAssignment: CellState?
    public var constraints: [any Constraint]

    public var name: String {
        "[\(row), \(col)]"
    }

    public var isAir: Bool {
        assignment == .air
    }
    
    public var isWater: Bool {
        assignment == .water
    }

    required init(row: Int,
                  col: Int,
                  internalDomain: Set<CellState>,
                  internalAssignment: CellState?,
                  constraints: [any Constraint]) {
        self.row = row
        self.col = col
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
        self.constraints = constraints
    }

    convenience init(row: Int, col: Int) {
        self.init(row: row,
                  col: col,
                  internalDomain: Set(CellState.allCases),
                  internalAssignment: nil,
                  constraints: [])
    }
}

extension CellVariable: Copyable {
    func copy() -> Self {
        return type(of: self).init(row: row,
                                   col: col,
                                   internalDomain: internalDomain,
                                   internalAssignment: internalAssignment,
                                   constraints: constraints)
    }
}
