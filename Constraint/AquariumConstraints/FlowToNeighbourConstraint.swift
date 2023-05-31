struct FlowToNeighbourConstraint: Constraint {
    let sourceCellName: String
    let neighbourCellName: String
    
    var variableNames: [String] {
        [sourceCellName, neighbourCellName]
    }
    
    init(sourceCell: CellVariable, neighbourCell: CellVariable) {
        self.sourceCellName = sourceCell.name
        self.neighbourCellName = neighbourCell.name
    }

    init(sourceCellName: String, neighbourCellName: String) {
        self.sourceCellName = sourceCellName
        self.neighbourCellName = neighbourCellName
    }

    func isSatisfied(state: SetOfVariables) -> Bool {
        guard let sourceCell = state.getVariable(sourceCellName, type: CellVariable.self),
              let neighbourCell = state.getVariable(sourceCellName, type: CellVariable.self) else {
            return false
        }
        // sourceCell.isWater -> neighbourCell.isWater (implication law)
        return sourceCell.isAir || neighbourCell.isWater
    }

    func isViolated(state: SetOfVariables) -> Bool {
        guard let sourceCell = state.getVariable(sourceCellName, type: CellVariable.self),
              let neighbourCell = state.getVariable(sourceCellName, type: CellVariable.self) else {
            return false
        }
        // sourceCell.isWater -> neighbourCell.isWater (implication law)
        return sourceCell.isWater && neighbourCell.isAir
    }
}

extension FlowToNeighbourConstraint: Copyable {
    func copy() -> FlowToNeighbourConstraint {
        self
    }
}
