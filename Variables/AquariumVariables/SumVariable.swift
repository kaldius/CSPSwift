class SumVariable: Variable {
    let size: Int
    var name: String
    var internalDomain: Set<[CellState]>
    var domainUndoStack: Stack<Set<[CellState]>>
    var internalAssignment: [CellState]?
    var constraints: [any Constraint]
    
    init(name: String, size: Int) {
        self.size = size
        self.name = name
        let cellDomains = [[CellState]](repeating: CellState.allCases, count: self.size)
        self.internalDomain = Set(Array<CellState>.possibleAssignments(domains: cellDomains))
        self.domainUndoStack = Stack()
        self.internalAssignment = nil
        self.constraints = []
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
