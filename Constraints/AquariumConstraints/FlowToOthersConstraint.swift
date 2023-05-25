/// Represents the constraint where water flows from `mainCell` to `adjacentCells`.
struct FlowToOthersConstraint: Constraint {
    let mainCell: CellVariable
    let adjacentCells: [CellVariable]
    
    var variables: [any Variable] {
        var allVariables = adjacentCells
        allVariables.append(mainCell)
        return allVariables
    }
    
    init(mainCell: CellVariable, adjacentCells: [CellVariable]) {
        self.mainCell = mainCell
        self.adjacentCells = adjacentCells
        addSelfToAllVariables()
    }
    
    /// The constraint is satisfied if either `mainCell`
    /// 1. has air and `adjacentCells` are assigned with any value, or
    /// 2. has water and its adjacent cells have water.
    ///
    /// If `mainCell` is unassigned, the constratint is not satisfied.
    var isSatisfied: Bool {
        let mainCellWater = mainCell.assignment == .water
        let mainCellAir = mainCell.assignment == .air
        
        let adjacentCellsAllWater = adjacentCells.allSatisfy({ $0.assignment == .water })
        let adjacentCellsAllAssigned = adjacentCells.allSatisfy({ $0.isAssigned })
        
        return (mainCellAir && adjacentCellsAllAssigned)
            || (mainCellWater && adjacentCellsAllWater)
    }
    
    /// The constraint is violated if `mainCell`
    /// 1. has water, and
    /// 2. there exists an adjacent cell with air.
    ///
    /// If `mainCell` is not assigned, it is not violated yet.
    var isViolated: Bool {
        let mainCellWater = mainCell.assignment == .water
        let anyAdjacentCellsAir = adjacentCells.contains(where: { $0.assignment == .air })
        // violated if mainCellWater and there exists an adjacent cell with air,
        // else not violated yet
        return mainCellWater && anyAdjacentCellsAir
    }
    // FIXME: this is not a binary constraint!!!!! use the 1100, 1110 shit!
}
