//
//  Constraint.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public protocol Constraint {
    var variables: [any Variable] { get }
    var isSatisfied: Bool { get }
    var isViolated: Bool { get }
}
