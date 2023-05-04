//
//  Variables.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public struct Variables<T: Value> {
    private var variableSet: Set<Variable<T>>
    
    public init(variableSet: Set<Variable<T>>) {
        self.variableSet = variableSet
    }
    
    public var isCompletelyAssigned: Bool {
        variableSet.allSatisfy({ $0.assignment != nil })
    }
    
    public var nextUnassignedVariable: Variable<T>? {
        // TODO: select unassigned variable using most-constrained-variable heuristic
        variableSet.first(where: { $0.assignment == nil })
    }
    
    public func orderDomainValues(for variable: Variable<T>) -> [T] {
        // TODO: order domain values using least-constraining-value heuristic
        Array(variable.remainingDomain)
    }
}
