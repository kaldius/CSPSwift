class SumVariable: Variable {
    let size: Int
    var name: String
    var domain: Set<[CellState]>
    var assignment: [CellState]?
    
    init(name: String, size: Int) {
        self.size = size
        self.name = name
        let cellDomains = [[CellState]](repeating: CellState.allCases, count: self.size)
        self.domain = Set(Array<CellState>.possibleAssignments(domains: cellDomains))
        self.assignment = nil
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
