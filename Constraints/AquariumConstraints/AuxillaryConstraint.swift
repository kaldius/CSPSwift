struct AuxillaryConstraint: Constraint {
    let mainVariable: CellVariable
    let sumVariable: SumVariable
    let index: Int
    var variables: [any Variable] {
        [mainVariable, sumVariable]
    }
    
    init(mainVariable: CellVariable, sumVariable: SumVariable, index: Int) {
        self.mainVariable = mainVariable
        self.sumVariable = sumVariable
        self.index = index
        addSelfToAllVariables()
    }
    
    var isSatisfied: Bool {
        sumVariable[index] == mainVariable.assignment
    }
    
    var isViolated: Bool {
        guard let sumVariableValue = sumVariable[index],
              let mainVariableValue = mainVariable.assignment else {
            return false
        }
        return sumVariableValue != mainVariableValue
    }
}
