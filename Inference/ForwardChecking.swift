/**
 A concrete implementation of the Forward Checking inference method.
 */
public struct ForwardChecking: InferenceEngine {
    public var variables: [any Variable]
    public var constraintSet: ConstraintSet
    
    public init(variables: [any Variable], constraintSet: ConstraintSet) {
        self.variables = variables
        self.constraintSet = constraintSet
    }

    public func makeNewInference(from variableSet: SetOfVariables) -> SetOfVariables {
        var copiedVariableSet = variableSet
        for constraint in constraintSet.allConstraints where constraint.containsAssignedVariable {
            for variable in constraint.variables where !variable.isAssigned {
                let inferredDomain = inferDomain(for: variable.name,
                                                 constraint: constraint,
                                                 variableSet: copiedVariableSet)
                copiedVariableSet.setDomain(for: variable.name, to: inferredDomain)
            }
        }
        return copiedVariableSet
    }

    // FIXME: BIG PROBLEM: after inferring a domain, we need to set it so that we can make further inferences
    private func inferDomain(for variableName: String,
                              constraint: some Constraint,
                              variableSet: SetOfVariables) -> [any Value] {
        guard let variable = variableSet.getVariable(name: variableName) else {
            assert(false)
        }
        if variable.isAssigned {
            // TODO: remove implicit unwrap
            return [variable.assignment!]
        }
        var copiedVariableSet = variableSet
        let domain = variableSet.getDomain(variableName: variableName)
        var newDomain = domain
        for domainValue in domain {
            // FIXME: constraint should take in the whole setOfVariables to check isViolated
            copiedVariableSet.assign(variableName, to: domainValue)
            if constraint.isViolated {
                newDomain.removeAll(where: { $0.isEqual(domainValue) })
            }
            copiedVariableSet.unassign(variableName)
        }
        return newDomain
    }
}

extension ForwardChecking: Copyable {
    public func copy() -> ForwardChecking {
        type(of: self).init(variables: variables.copy(),
                            constraintSet: constraintSet.copy())
    }
}
