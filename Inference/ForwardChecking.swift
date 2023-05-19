//
//  ForwardChecking.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public struct ForwardChecking<T: Value>: InferenceEngine {
    public var variables: [any Variable]
    public var constraints: Constraints
    
    public init(variables: [any Variable], constraints: Constraints) {
        self.variables = variables
        self.constraints = constraints
    }
    
    public func makeNewInference() -> Inference {
        var inference = Inference()
        // for constraints with assigned variables
        for constraint in constraints.allConstraints where containsAssignedVariable(constraint){
            // for unassigned variables
            for variable in constraint.variables where !variable.isAssigned {
                let inferredDomain = inferDomain(for: variable, constraint: constraint)
                inference.addDomain(for: variable, domain: inferredDomain)
            }
        }
        return inference
    }
    
    private func containsAssignedVariable(_ constraint: any Constraint) -> Bool {
        constraint.variables.contains(where: { $0.isAssigned })
    }
    
    private func inferDomain(for variable: some Variable, constraint: some Constraint) -> [some Value] {
        var newDomain = variable.domain
        for domainValue in variable.domain {
            variable.assignment = domainValue
            if constraint.isViolated {
                newDomain.remove(domainValue)
            }
        }
        return Array(newDomain)
    }
}
