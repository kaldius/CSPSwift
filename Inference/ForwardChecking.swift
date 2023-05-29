/**
 A concrete implementation of the Forward Checking inference method.
 */
public struct ForwardChecking: InferenceEngine {
    public var variables: [any Variable]
    public var constraintCollection: ConstraintCollection
    
    public init(variables: [any Variable], constraintCollection: ConstraintCollection) {
        self.variables = variables
        self.constraintCollection = constraintCollection
    }
    
    public func makeNewInference() -> VariableDomainState {
        var variableDomainState = VariableDomainState(from: variables)
        for constraint in constraintCollection.allConstraints where constraint.containsAssignedVariable {
            for variable in constraint.variables where !variable.isAssigned {
                let inferredDomain = inferDomain(for: variable, constraint: constraint)
                variableDomainState.addDomain(for: variable, domain: inferredDomain)
            }
        }
        return variableDomainState
    }

    // FIXME: BIG PROBLEM: after inferring a domain, we need to set it so that we can make further inferences
    private func inferDomain(for variable: some Variable, constraint: some Constraint) -> [some Value] {
        if variable.isAssigned {
            var newDomain = variable.emptyValueArray
            newDomain.append(variable.assignment!)
            return newDomain
        }
        var newDomain = variable.domain
        for domainValue in variable.domain {
            variable.assign(to: domainValue)
            if constraint.isViolated {
                newDomain.remove(domainValue)
            }
            variable.unassign()
        }
        return Array(newDomain)
    }
}
