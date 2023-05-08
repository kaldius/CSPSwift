//
//  Variable.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public class Variable<T: Value> {
    public let name: String
    private(set) var domain: Set<T>
    
    /// If setting to a value that is not in `remainingDomain`,
    /// the revert back to old value.
    public var assignment: T? {
        didSet {
            if let newValue = assignment, !domain.contains(newValue) {
                assignment = oldValue
            }
        }
    }
    
    public init(name: String,
                domain: Set<T> = Set()) {
        self.name = name
        self.assignment = nil
        self.domain = domain
    }
    
    /// Returns true if this variable can be set to `newAssignment`,
    /// false otherwise.
    public func canAssign(to newAssignment: T) -> Bool {
        domain.contains(newAssignment)
    }
    
    // TODO: need to update domain?
    public func unassign() {
        assignment = nil
    }
}

extension Variable: Equatable {
    public static func == (lhs: Variable, rhs: Variable) -> Bool {
        lhs.name == rhs.name
    }
}

extension Variable: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }
}
