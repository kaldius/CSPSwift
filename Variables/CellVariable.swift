//
//  CellVariable.swift
//  
//
//  Created by Quan Teng Foong on 20/5/23.
//

import Foundation

class CellVariable: Variable {
    public let row: Int
    public let col: Int
    
    public var name: String {
        "[\(row), \(col)]"
    }
    public var domain: Set<Bool> = Set([true, false])
    public var assignment: Bool?
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
