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

/*
public struct BinaryConstraint<T: Value> : Constraint {
    public let variable1: Variable<T>
    public let variable2: Variable<T>
    // TODO: I want `variables` to be a "homogeneous" array of Variable<? extends T>, then the condition to take in all the different types. How?
    public let variables: [Variable<T>]
    private let condition: (T, T) -> Bool
    
    public init(variable1: Variable<T>,
                variable2: Variable<T>,
                condition: @escaping (T, T) -> Bool) {
        self.variable1 = variable1
        self.variable2 = variable2
        self.variables = [variable1, variable2]
        self.condition = condition
    }
    
    /// Checks if the closure is able to take in 2 variables
    private func checkCondition(_ closure: (T...) throws -> Bool) -> Bool {
        do {
            guard let testValue1 = variable1.domain.first,
                  let testValue2 = variable2.domain.first else {
                return false
            }
            let _ = try closure(testValue1, testValue2)
            return true
        } catch {
            return false
        }
    }
    
    public var isSatisfied: Bool {
        guard let currentAssignment1 = variable1.assignment,
              let currentAssignment2 = variable2.assignment else {
            return false
        }
        return condition(currentAssignment1, currentAssignment2)
    }
}

*/
