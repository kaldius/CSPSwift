/**
 A protocol for all Unary constraints.
 */
public protocol UnaryConstraint: Constraint {
    var variableName: String { get }
}

extension UnaryConstraint {
    func restrictDomain(state: VariableSet) throws -> VariableSet {
        guard let variable = state.getVariable(variableName, type: TernaryVariable.self) else {
            return state
        }
        var copiedState = state
        var newDomain = variable.domain
        for domainValue in variable.domain {
            try copiedState.assign(variableName, to: domainValue)
            if try isViolated(state: copiedState) {
                newDomain.remove(domainValue)
            }
            copiedState.unassign(variableName)
        }
        try copiedState.setDomain(for: variableName, to: Array(newDomain))
        return copiedState
    }
}
