/**
 An `InferenceEngine` that looks at all `Variable`s and only removes domain `Value`s
 that will violate some `Constraint`.
 */
struct ForwardChecking: InferenceEngine {
    func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) throws -> VariableSet? {
        var copiedState = state
        for variable in state.variables {
            let variableName = variable.name
            let newDomain = try copiedState.getDomain(variableName).filter({ domainValue in
                try testCanAssign(variableName,
                                  to: domainValue,
                                  state: state,
                                  constraintSet: constraintSet)
            })
            try copiedState.setDomain(for: variableName, to: newDomain)
        }
        return copiedState
    }

    private func testCanAssign(_ variableName: String,
                               to value: some Value,
                               state: VariableSet,
                               constraintSet: ConstraintSet) throws -> Bool {
        var copiedState = state
        guard try copiedState.canAssign(variableName, to: value) else {
            return false
        }
        try copiedState.assign(variableName, to: value)
        let anyViolated = try constraintSet.anyViolated(state: copiedState)
        copiedState.unassign(variableName)
        return !anyViolated
    }
}
