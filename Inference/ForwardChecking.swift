/**
 A concrete implementation of the Forward Checking inference method.
 */

public struct ForwardChecking: InferenceEngine {
    public var variables: [any Variable]
    public var constraints: Constraints
    
    public init(variables: [any Variable], constraints: Constraints) {
        self.variables = variables
        self.constraints = constraints
    }
    
    public func makeNewInference() -> Inference {
        var inference = Inference()
        // for constraints with assigned variables
        for constraint in constraints.allConstraints where constraint.containsAssignedVariable {
            print("checking \(constraint.variables[0].name) greater than \(constraint.variables[1].name)")
            // for unassigned variables
            for variable in constraint.variables where !variable.isAssigned {
                let inferredDomain = inferDomain(for: variable, constraint: constraint)
                inference.addDomain(for: variable, domain: inferredDomain)
            }
        }
        return inference
    }

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
