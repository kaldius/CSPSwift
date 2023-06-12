/**
 Selects the next unassigned variable using the **Minimum Remaining Values** heuristic.
 i.e. selects an unassigned `Variable` with the smallest domain.
 */
struct MinimumRemainingValues: NextVariableSelector {
    func nextUnassignedVariable(state: VariableSet) -> (any Variable)? {
        state.unassignedVariables.min(by: { $0.domainSize < $1.domainSize })
    }
}
