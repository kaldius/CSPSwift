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

struct UnaryConstraint<T: Comparable>: Constraint {
    private let assignments: Assignments
    private let variable: Variable
    private let value: Value<T>
    private let comp: (Value<T>, Value<T>) -> Bool
    
    public var isSatisfied: Bool {
        guard let currentAssignment = assignments.getAssignment(of: variable) else {
            return false
        }
        return comp(currentAssignment, value)
    }
    
    init(assignments: Assignments,
         variable: Variable,
         value: Value<T>,
         comp: @escaping (Value<T>, Value<T>) -> Bool) {
        self.assignments = assignments
        self.variable = variable
        self.value = value
        self.comp = comp
    }
    
    
}
