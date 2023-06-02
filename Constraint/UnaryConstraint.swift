public protocol UnaryConstraint: Constraint {
    var variableName: String { get }
}

extension UnaryConstraint {
    // TODO: test
    func restrictDomain(state: SetOfVariables) -> SetOfVariables {
        guard let variable = state.getVariable(variableName, type: TernaryVariable.self) else {
            return state
        }
        var copiedState = state
        var newDomain = variable.domainAsArray
        for domainValue in variable.domain {
            copiedState.assign(variableName, to: domainValue)
            if isViolated(state: copiedState) {
                newDomain.removeAll(where: { $0.isEqual(domainValue) })
            }
            copiedState.unassign(variableName)
        }
        copiedState.setDomain(for: variableName, to: newDomain)
        return copiedState
    }
}
