/**
 A concrete implementation of the Forward Checking inference method.
 */
public struct ForwardChecking: InferenceEngine {
    public var constraintSet: ConstraintSet
    
    public init(constraintSet: ConstraintSet) {
        self.constraintSet = constraintSet
    }

    public func makeNewInference(from state: SetOfVariables) -> SetOfVariables? {
        var copiedVariableSet = state
        for constraint in constraintSet.allConstraints {
            for variableName in constraint.variableNames {
                let inferredDomain = inferDomain(for: variableName,
                                                 constraint: constraint,
                                                 variableSet: copiedVariableSet)
                if inferredDomain.isEmpty {
                    // impossible to carry on
                    return nil
                }
                copiedVariableSet.setDomain(for: variableName, to: inferredDomain)
            }
        }
        return copiedVariableSet
    }

    private func inferDomain(for variableName: String,
                              constraint: some Constraint,
                              variableSet: SetOfVariables) -> [any Value] {
        guard let variable = variableSet.getVariable(variableName) else {
            assert(false)
        }
        if variable.isAssigned {
            // TODO: remove implicit unwrap
            return [variable.assignment!]
        }
        var copiedVariableSet = variableSet
        let domain = variableSet.getDomain(variableName)
        var newDomain = domain
        for domainValue in domain {
            copiedVariableSet.assign(variableName, to: domainValue)
            if constraint.isViolated(state: copiedVariableSet) {
                newDomain.removeAll(where: { $0.isEqual(domainValue) })
            }
            copiedVariableSet.unassign(variableName)
        }
        return newDomain
    }
}

extension ForwardChecking: Copyable {
    public func copy() -> ForwardChecking {
        self
    }
}
