/**
 A protocol for all Unary constraints.
 */
public protocol UnaryConstraint: Constraint {
    var variableName: String { get }
}

extension UnaryConstraint {
    func restrictDomain(state: VariableSet) -> VariableSet {
        guard let variable = state.getVariable(variableName, type: TernaryVariable.self) else {
            return state
        }
        var copiedState = state
        var newDomain = variable.domain
        for domainValue in variable.domain {
            copiedState.assign(variableName, to: domainValue)
            if isViolated(state: copiedState) {
                newDomain.remove(domainValue)
            }
            copiedState.unassign(variableName)
        }
        copiedState.setDomain(for: variableName, to: Array(newDomain))
        return copiedState
    }
}
