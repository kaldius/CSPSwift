//
//  BinaryConstraint.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//
/**
 Represents a constraint of the form [(Variable ^ Variable) * Value],
 where * is some comparison operator, and ^ is some binary operator
 that returns a `Value`.
 */
import Foundation

struct BinaryConstraint<T: Comparable> : Constraint {
    private let assignments: Assignments
    private let variable1: Variable
    private let variable2: Variable
    private let value: Value<T>
    private let op: (Value<T>, Value<T>) -> Value<T>
    private let comp: (Value<T>, Value<T>) -> Bool
    
    private var variablesCombined: Value<T>? {
        guard let currentAssignment1 = assignments.getAssignment(of: variable1),
              let currentAssignment2 = assignments.getAssignment(of: variable2) else {
            return nil
        }
        let lhs = op(currentAssignment1, currentAssignment2)
    }
    
    public var isSatisfied: Bool {
        guard let lhs = variablesCombined else {
            return false
        }
        return comp(lhs, value)
    }
    
    init(assignments: Assignments,
         variable1: Variable,
         variable2: Variable,
         value: Value<T>,
         comp: @escaping (Value<T>, Value<T>) -> Bool) {
        self.assignments = assignments
        self.variable1 = variable1
        self.variable2 = variable2
        self.value = value
        self.comp = comp
    }
}
