//
//  ForwardChecking.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public struct ForwardChecking<T: Value>: InferenceEngine {
    public var variables: Set<Variable<T>>
    public var constraints: Constraints
    
    public init(variables: Set<Variable<T>>, constraints: Constraints) {
        self.variables = variables
        self.constraints = constraints
    }
    
    public func makeNewInference() -> Inference<T> {
        // for all variables with assignments,
        // for all constraints,
        // for all variables in constraints without assignments
        // test each domain value
        // if pass, keep, if fail, remove
        /*
        for constraint in constraints.allConstraints {
            for variable in constraint.variables where variable.assignment == nil {
                
            }
        }
         */
        return Inference()
    }
    
    private func inferFrom(constraint: any Constraint) {
        if let unaryConstraint = constraint as? UnaryConstraint<T> {
            inferFrom(unaryConstraint: unaryConstraint)
        }
        if let binaryConstraint = constraint as? BinaryConstraint<T> {
            inferFrom(binaryConstraint: binaryConstraint)
        }
    }
    
    private func inferFrom(unaryConstraint: UnaryConstraint<T>) {
        if unaryConstraint.variable.domain.count == 1 {
            return
        }
        // FIXME: fix
        let newDomain = unaryConstraint.variable.domain.compactMap({ domainValue in
            domainValue
        })
    }
    
    private func inferFrom(binaryConstraint: BinaryConstraint<T>) {
        
    }
}
