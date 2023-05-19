//
//  Variable.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public protocol Variable: AnyObject, Hashable {
    associatedtype ValueType: Value
    
    var name: String { get }
    var domain: Set<ValueType> { get set }
    var assignment: ValueType? { get set }
}

extension Variable {
    public var domainAsArray: [ValueType] {
        Array(domain)
    }
    
    public var domainSize: Int {
        domain.count
    }
    
    public var isAssigned: Bool {
        assignment != nil
    }
    
    /// Returns true if this variable can be set to `newAssignment`,
    /// false otherwise.
    public func canAssign(to newAssignment: some Value) -> Bool {
        guard let castedNewAssignment = newAssignment as? ValueType else {
            return false
        }
        return assignment == nil && domain.contains(castedNewAssignment)
    }
    
    @discardableResult
    public func assign(to newAssignment: some Value) -> Bool {
        guard let castedNewAssignment = newAssignment as? ValueType,
              domain.contains(castedNewAssignment) else {
            return false
        }
        assignment = castedNewAssignment
        return true
    }
    
    public func setDomain(newDomain: [any Value]) {
        let castedDomain = newDomain.compactMap({ $0 as? ValueType })
        guard castedDomain.count > 0 else {
            assert(false)
        }
        domain = Set(castedDomain)
    }
    
    // TODO: need to update domain?
    public func unassign() {
        assignment = nil
    }
}

extension Variable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.assignment == rhs.assignment
    }
}

extension Variable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
