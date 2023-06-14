/**
 An `InferenceEngine` that looks at all `Variable`s and only removes domain `Value`s
 that will violate some `Constraint`.
 */
struct ForwardChecking: InferenceEngine {
    func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) -> VariableSet? {
        var copiedState = state
        for variable in state.variables {
            let variableName = variable.name
            let newDomain = copiedState.getDomain(variableName).filter({ testCanAssign(variableName,
                                                                                        to: $0,
                                                                                        state: state,
                                                                                        constraintSet: constraintSet) })
            copiedState.setDomain(for: variableName, to: newDomain)
        }
        return copiedState
    }

    private func testCanAssign(_ variableName: String,
                               to value: some Value,
                               state: VariableSet,
                               constraintSet: ConstraintSet) -> Bool {
        var copiedState = state
        guard copiedState.canAssign(variableName, to: value) else {
            return false
        }
        copiedState.assign(variableName, to: value)
        let anyViolated = constraintSet.anyViolated(state: copiedState)
        copiedState.unassign(variableName)
        return !anyViolated
    }
}
