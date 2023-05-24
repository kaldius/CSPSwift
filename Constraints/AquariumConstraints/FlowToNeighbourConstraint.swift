struct FlowToNeighbourConstraint: Constraint {
    let sourceCell: CellVariable
    let neighbourCell: CellVariable
    
    var variables: [any Variable] {
        [sourceCell, neighbourCell]
    }
    
    init(sourceCell: CellVariable, neighbourCell: CellVariable) {
        self.sourceCell = sourceCell
        self.neighbourCell = neighbourCell
    }
    
    var isSatisfied: Bool {
        // sourceCell.isWater -> neighbourCell.isWater (implication law)
        sourceCell.isAir || neighbourCell.isWater
    }
    
    var isViolated: Bool {
        sourceCell.isWater && neighbourCell.isAir
    }
}
