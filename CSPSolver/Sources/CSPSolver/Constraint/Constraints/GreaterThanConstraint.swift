/**
 A constraint where `variableA` must be greater than `variableB`.

 Note: could theoretically work on any `ComparableVariable` but that has not been implemented.
 */
struct GreaterThanConstraint: BinaryConstraint {
    let variableAName: String
    let variableBName: String

    var variableNames: [String] {
        [variableAName, variableBName]
    }

    init(_ variableA: IntVariable, isGreaterThan variableB: IntVariable) {
        self.variableAName = variableA.name
        self.variableBName = variableB.name
    }

    func isSatisfied(state: VariableSet) throws -> Bool {
        guard let valueA = try state.getAssignment(variableAName, type: IntVariable.self),
              let valueB = try state.getAssignment(variableBName, type: IntVariable.self) else {
            return false
        }
        return valueA.isGreaterThan(valueB)
    }

    func isViolated(state: VariableSet) throws -> Bool {
        guard let valueA = try state.getAssignment(variableAName, type: IntVariable.self),
              let valueB = try state.getAssignment(variableBName, type: IntVariable.self) else {
            return false
        }
        return valueA.isLessThan(valueB) || valueA.isEqual(valueB)
    }
}
