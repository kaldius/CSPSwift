//
//  BacktrackingSolver.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public struct BacktrackingSolver {
    /// Returns the solvable in a solved state if it can be solved,
    /// returns `nil` otherwise.
    public func backtrack(variableSet: VariableSet, constraints: Constraints) -> Bool {
        if variableSet.isCompletelyAssigned && constraints.allSatisfied {
            return true
        }
        guard let unassignedVariable = variableSet.nextUnassignedVariable else {
            // if there is no nextUnassignedVariable and the constraints are not
            // all satisfied, search has failed
            return false
        }
        for domainValue in variableSet.orderDomainValues(for: unassignedVariable) {
            if unassignedVariable.canAssign(to: domainValue) {
                unassignedVariable.assign(to: domainValue)
                // make new inferences (without setting yet)
                if true { // !inference.leadsToFailure {
                    // set new inferences
                    let result = backtrack(variableSet: variableSet, constraints: constraints)
                    if result {
                        return true
                    }
                    // remove inferences from csp
                }
                unassignedVariable.unassign()
            }
        }
        return false
    }
    
    private func checkAssignability(for variable: some Variable, to value: some Value) -> Bool {
        variable.canAssign(to: value)
    }
}
