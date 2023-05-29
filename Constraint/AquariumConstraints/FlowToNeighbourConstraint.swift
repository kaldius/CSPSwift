struct FlowToNeighbourConstraint: Constraint {
    let sourceCell: CellVariable
    let neighbourCell: CellVariable
    
    var variables: [any Variable] {
        [sourceCell, neighbourCell]
    }
    
    init(sourceCell: CellVariable, neighbourCell: CellVariable) {
        self.sourceCell = sourceCell
        self.neighbourCell = neighbourCell
        addSelfToAllVariables()
    }
    
    var isSatisfied: Bool {
        // sourceCell.isWater -> neighbourCell.isWater (implication law)
        sourceCell.isAir || neighbourCell.isWater
    }
    
    var isViolated: Bool {
        sourceCell.isWater && neighbourCell.isAir
    }
}

extension FlowToNeighbourConstraint: Copyable {
    func copy() -> FlowToNeighbourConstraint {
        type(of: self).init(sourceCell: sourceCell.copy(),
                            neighbourCell: neighbourCell.copy())
    }
}
