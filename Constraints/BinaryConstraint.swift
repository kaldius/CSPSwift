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

public struct BinaryConstraint<T: Value> : Constraint {
    private let variable1: Variable<T>
    private let variable2: Variable<T>
    private let condition: (T, T) -> Bool
    
    public init(variable1: Variable<T>,
                variable2: Variable<T>,
                condition: @escaping (T, T) -> Bool) {
        self.variable1 = variable1
        self.variable2 = variable2
        self.condition = condition
    }
    
    public var isSatisfied: Bool {
        guard let currentAssignment1 = variable1.assignment,
              let currentAssignment2 = variable2.assignment else {
            return false
        }
        return condition(currentAssignment1, currentAssignment2)
    }
}
