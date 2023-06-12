struct MinimumRemainingValues: NextVariableSelector {
    func nextUnassignedVariable(state: VariableSet) -> (any Variable)? {
        state.variables.min(by: { $0.domainSize < $1.domainSize })
    }
}
