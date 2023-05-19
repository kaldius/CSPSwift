//
//  IntVariable.swift
//  
//
//  Created by Quan Teng Foong on 13/5/23.
//

import Foundation

public class IntVariable: Variable {
    public var name: String
    public var domain: Set<Int>
    
    /// If setting to a value that is not in `domain`,
    /// the revert back to old value.
    public var assignment: Int? {
        didSet {
            if let newValue = assignment, !domain.contains(newValue) {
                assignment = oldValue
            }
        }
    }
    
    init(name: String, domain: Set<Int> = Set()) {
        self.name = name
        self.domain = domain
        self.assignment = nil
    }
}
