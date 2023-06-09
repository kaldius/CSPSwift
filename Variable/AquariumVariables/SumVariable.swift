/**
 A `Varaible` representing the sum of all `CellVariable`s with water in them.
 */
// TODO: TEST
struct SumVariable: Variable {
    let size: Int
    var name: String
    var internalDomain: Set<[CellState]>
    var internalAssignment: [CellState]?

    init(name: String, size: Int) {
        let cellDomains = [[CellState]](repeating: CellState.allCases, count: size)
        let domain = Set(Array<CellState>.possibleAssignments(domains: cellDomains))

        self.init(name: name,
                  size: size,
                  internalDomain: domain,
                  internalAssignment: nil)
    }
    
    init(name: String,
         size: Int,
         internalDomain: Set<[CellState]>,
         internalAssignment: [CellState]?) {
        self.name = name
        self.size = size
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
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
