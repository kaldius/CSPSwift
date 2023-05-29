/**
 Represents the entire CSP, with `Variable`s and `Constraint`s.
 */
class ConstraintSatisfactionProblem {
    let variableSet: VariableSet
    var constraintSet: ConstraintSet

    required init(variableSet: VariableSet, constraintSet: ConstraintSet) {
        self.variableSet = variableSet
        self.constraintSet = constraintSet
    }
}

extension ConstraintSatisfactionProblem: Copyable {
    func copy() -> Self {
        type(of: self).init(variableSet: variableSet.copy(),
                            constraintSet: constraintSet)
    }
}
