//
//  Constraint.swift
//  
//
//  Created by Quan Teng Foong on 2/5/23.
//

import Foundation

public protocol Constraint {
    associatedtype T: Value
    var variables: [Variable<T>] { get }
    // var condition: (T...) throws -> Bool { get }
    var isSatisfied: Bool { get }
}
