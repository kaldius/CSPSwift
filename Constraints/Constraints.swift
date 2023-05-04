//
//  Constraints.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

struct Constraints {
    private let assignments: Assignments
    private var allConstraints: Set<Constraint>
    
    init(assignments: Assignments) {
        self.assignments = assignments
        self.allConstraints = Set()
    }
    
}
