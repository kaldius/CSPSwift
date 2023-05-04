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
    
    public var nextUnassignedVariable: Variable<T> {
        return Variable(name: "stub")
    }
    
    public func orderDomainValues(for variable: Variable<T>) -> [T] {
        return []
    }
    
}
