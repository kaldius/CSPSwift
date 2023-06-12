/**
 A protocol that all heuristics for selecting the **NextUnassignedVariable** must conform to.
 */
protocol NextVariableSelector {
    func nextUnassignedVariable(state: VariableSet) -> (any Variable)?
}
