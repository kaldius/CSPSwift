//
//  UnaryConstraint.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//
/**
 Represents a constraint of the form [Variable * Value],
 where * is some comparison operator.
 */

import Foundation

public struct UnaryConstraint<T: Value>: Constraint {
    private let variable: Variable<T>
    private let condition: (T) -> Bool
    
    public init(variable: Variable<T>,
                condition: @escaping (T) -> Bool) {
        self.variable = variable
        self.condition = condition
    }
    
    public var isSatisfied: Bool {
        guard let currentAssignment = variable.assignment else {
            return false
        }
        return condition(currentAssignment)
    }
}
