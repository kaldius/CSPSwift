//
//  BacktrackingSolver.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public struct BacktrackingSolver<T: Value> {
    /// Returns the solvable in a solved state if it can be solved,
    /// returns `nil` otherwise.
    public func backtrack(variables: Variables<T>, constraints: Constraints) -> Variables<T>? {
        if variables.isCompletelyAssigned && constraints.allSatisfied {
            return variables
        }
        guard let unassignedVariable = variables.nextUnassignedVariable else {
            // if there is no nextUnassignedVariable and the constraints are not
            // all satisfied, search has failed
            return nil
        }
        for domainValue in variables.orderDomainValues(for: unassignedVariable) {
            if unassignedVariable.canAssign(to: domainValue) {
                unassignedVariable.assignment = domainValue
                // make new inferences (without setting yet)
                if true { // !inferences.leadsToFailure {
                    // set new inferences
                    let result = backtrack(variables: variables, constraints: constraints)
                    if result != nil {
                        return result
                    }
                    // remove inferences from csp
                }
                unassignedVariable.unassign()
            }
        }
        return nil
    }
}
