/**
A constraint where `variableA` must be equal to `varibleB`.

Note: could theoretically work on any `EquatableVariable` but that has not been implemented.
 */

struct EqualToConstraint: Constraint {
    let variableA: IntVariable
    let variableB: IntVariable

    var variables: [any Variable] {
        [variableA, variableB]
    }

    init(_ variableA: IntVariable, isEqualTo variableB: IntVariable) {
        self.variableA = variableA
        self.variableB = variableB
    }

    var isSatisfied: Bool {
        guard let valueA = variableA.assignment,
              let valueB = variableB.assignment else {
            return false
        }
        return valueA == valueB
    }

    var isViolated: Bool {
        guard let valueA = variableA.assignment,
              let valueB = variableB.assignment else {
            return false
        }
        return valueA != valueB
    }
}
