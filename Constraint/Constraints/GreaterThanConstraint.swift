/**
 A constraint where `variableA` must be greater than `variableB`.

 Note: could theoretically work on any `ComparableVariable` but that has not been implemented.
 */
struct GreaterThanConstraint: Constraint {
    let variableAName: String
    let variableBName: String

    var variableNames: [String] {
        [variableAName, variableBName]
    }

    init(_ variableA: IntVariable, isGreaterThan variableB: IntVariable) {
        self.variableAName = variableA.name
        self.variableBName = variableB.name
    }

    func isSatisfied(state: SetOfVariables) -> Bool {
        guard let valueA = state.getAssignment(variableAName, type: IntVariable.self),
              let valueB = state.getAssignment(variableBName, type: IntVariable.self) else {
            return false
        }
        return valueA.isGreaterThan(valueB)
    }

    func isViolated(state: SetOfVariables) -> Bool {
        guard let valueA = state.getAssignment(variableAName, type: IntVariable.self),
              let valueB = state.getAssignment(variableBName, type: IntVariable.self) else {
            return false
        }
        return valueA.isLessThan(valueB) || valueA.isEqual(valueB)
    }
}

extension GreaterThanConstraint: Copyable {
    func copy() -> GreaterThanConstraint {
        self
    }
}
