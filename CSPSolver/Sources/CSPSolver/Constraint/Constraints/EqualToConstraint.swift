/**
A constraint where `variableA` must be equal to `varibleB`.

Note: could theoretically work on any `EquatableVariable` but that has not been implemented.
 */
struct EqualToConstraint: BinaryConstraint {
    let variableAName: String
    let variableBName: String

    var variableNames: [String] {
        [variableAName, variableBName]
    }

    init(_ variableA: IntVariable, isEqualTo variableB: IntVariable) {
        self.variableAName = variableA.name
        self.variableBName = variableB.name
    }

    func isSatisfied(state: VariableSet) -> Bool {
        guard let valueA = state.getAssignment(variableAName, type: IntVariable.self),
              let valueB = state.getAssignment(variableBName, type: IntVariable.self) else {
            return false
        }
        return valueA == valueB
    }

    func isViolated(state: VariableSet) -> Bool {
        guard let valueA = state.getAssignment(variableAName, type: IntVariable.self),
              let valueB = state.getAssignment(variableBName, type: IntVariable.self) else {
            return false
        }
        return valueA != valueB
    }
}
