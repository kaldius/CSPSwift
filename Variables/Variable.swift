//
//  Variable.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public class Variable<T: Value> {
    public let name: String
    public var assignment: T?
    public let domain: [T]
    private(set) var remainingDomain: [T]
    
    public init(name: String,
         assignment: T? = nil,
         domain: [T] = []) {
        self.name = name
        self.assignment = nil
        self.domain = domain
        self.remainingDomain = domain
    }
    
    public func pruneRemainingDomain(toSatisfy closure: (T) -> Bool) {
        remainingDomain.removeAll(where: closure)
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
