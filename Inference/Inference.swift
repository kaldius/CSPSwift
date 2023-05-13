//
//  Inference.swift
//  
//
//  Created by Quan Teng Foong on 9/5/23.
//

import Foundation

public struct Inference<T: Value> {
    private(set) var variableToDomain: [Variable<T>: Set<T>]
    
    init(variableToDomain: [Variable<T> : Set<T>] = [:]) {
        self.variableToDomain = variableToDomain
    }
    
    public var leadsToFailure: Bool {
        variableToDomain.contains(where: { keyValuePair in
            keyValuePair.value.isEmpty })
    }
    
    public var numConsistentDomainValues: Int {
        variableToDomain.reduce(0, { count, keyValuePair in
            count + keyValuePair.key.domain.count
        })
    }
    
    public mutating func addDomain(for variable: Variable<T>, domain: Set<T>) {
        variableToDomain[variable] = domain
    }
    
    public func getDomain(for variable: Variable<T>) -> Set<T>? {
        variableToDomain[variable]
    }
}
