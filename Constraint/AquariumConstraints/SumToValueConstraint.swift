struct SumToValueConstraint: Constraint {
    let sumVariable: SumVariable
    let goal: Int
    
    var variables: [any Variable] {
        [sumVariable]
    }
    
    init(sumVariable: SumVariable, goal: Int) {
        self.sumVariable = sumVariable
        self.goal = goal
    }
    
    var isSatisfied: Bool {
        sumVariable.sum == goal
    }
    
    var isViolated: Bool {
        let sum = sumVariable.sum
        return sum != nil && sum != goal
    }
}

extension SumToValueConstraint: Copyable {
    func copy() -> SumToValueConstraint {
        self
    }
}
