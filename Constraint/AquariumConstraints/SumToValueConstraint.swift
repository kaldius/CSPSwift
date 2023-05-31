struct SumToValueConstraint: Constraint {
    let sumVariableName: String
    let goal: Int
    
    var variableNames: [String] {
        [sumVariableName]
    }
    
    init(sumVariable: SumVariable, goal: Int) {
        self.sumVariableName = sumVariable.name
        self.goal = goal
    }

    func isSatisfied(state: SetOfVariables) -> Bool {
        guard let sumVariable = state.getVariable(sumVariableName, type: SumVariable.self) else {
            return false
        }
        return sumVariable.sum == goal
    }

    func isViolated(state: SetOfVariables) -> Bool {
        guard let sumVariable = state.getVariable(sumVariableName, type: SumVariable.self) else {
            return false
        }
        let sum = sumVariable.sum
        return sum != nil && sum != goal
    }
}

extension SumToValueConstraint: Copyable {
    func copy() -> SumToValueConstraint {
        self
    }
}
