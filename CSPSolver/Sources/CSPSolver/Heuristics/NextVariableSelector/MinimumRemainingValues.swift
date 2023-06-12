struct MinimumRemainingValues: NextVariableSelector {
    func nextUnassignedVariable(state: VariableSet) -> (any Variable)? {
        state.unassignedVariables.min(by: { $0.domainSize < $1.domainSize })
    }
}
