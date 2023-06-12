protocol NextVariableSelector {
    func nextUnassignedVariable(state: VariableSet) -> (any Variable)?
}
