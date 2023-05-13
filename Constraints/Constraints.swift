//
//  Constraints.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public struct Constraints {
    private(set) var allConstraints: [any Constraint]
    
    public init(allConstraints: [any Constraint] = []) {
        self.allConstraints = allConstraints
    }
    
    public mutating func add(constraint: any Constraint) {
        allConstraints.append(constraint)
    }
    
    public var allSatisfied: Bool {
        return allConstraints.allSatisfy({ $0.isSatisfied })
    }
}
