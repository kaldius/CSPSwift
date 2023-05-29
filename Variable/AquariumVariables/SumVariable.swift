/**
 A `Varaible` representing the sum of all `CellVariable`s with water in them.
 */
// TODO: TEST
class SumVariable: Variable {
    let size: Int
    var name: String
    var internalDomain: Set<[CellState]>
    var internalAssignment: [CellState]?
    var constraints: [any Constraint]

    convenience init(name: String, size: Int) {
        let cellDomains = [[CellState]](repeating: CellState.allCases, count: size)
        let domain = Set(Array<CellState>.possibleAssignments(domains: cellDomains))

        self.init(name: name,
                  size: size,
                  internalDomain: domain,
                  internalAssignment: nil,
                  constraints: [])
    }

    required init(name: String,
                  size: Int,
                  internalDomain: Set<[CellState]>,
                  internalAssignment: [CellState]?,
                  constraints: [any Constraint]) {
        self.name = name
        self.size = size
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
        self.constraints = constraints
    }

    var sum: Int? {
        return assignment?.reduce(0, { prevResult, cellState in
            let cellHasWater = cellState == .water
            return prevResult + (cellHasWater ? 1 : 0)
        })
    }
    
    subscript(_ idx: Int) -> CellState? {
        assignment?[idx]
    }
}

extension SumVariable: Copyable {
    public func copy() -> Self {
        return type(of: self).init(name: name,
                                   size: size,
                                   internalDomain: internalDomain,
                                   internalAssignment: internalAssignment,
                                   constraints: constraints)
    }
}
