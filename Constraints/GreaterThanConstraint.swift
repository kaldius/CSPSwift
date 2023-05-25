/**
 A constraint where `variableA` must be greater than `variableB`.

 Note: could theoretically work on any `ComparableVariable` but that has not been implemented.
 */

struct GreaterThanConstraint: Constraint {
    let variableA: IntVariable
    let variableB: IntVariable

    var variables: [any Variable] {
        [variableA, variableB]
    }

    init(_ variableA: IntVariable, isGreaterThan variableB: IntVariable) {
        self.variableA = variableA
        self.variableB = variableB
        addSelfToAllVariables()
    }

    var isSatisfied: Bool {
        guard let valueA = variableA.assignment,
              let valueB = variableB.assignment else {
            return false
        }
        return valueA > valueB
    }

    var isViolated: Bool {
        guard let valueA = variableA.assignment,
              let valueB = variableB.assignment else {
            return false
        }
        return valueA <= valueB
    }
}
