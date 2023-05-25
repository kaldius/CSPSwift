//
//  Inference.swift
//  
//
//  Created by Quan Teng Foong on 9/5/23.
//

import Foundation

public struct Inference {
    private var variableNameToDomain: [String: [any Value]]
    private var variableNameToVariable: [String: any Variable]
    
    init() {
        self.variableNameToDomain = [:]
        self.variableNameToVariable = [:]
    }
    
    public var leadsToFailure: Bool {
        variableNameToDomain.contains(where: { keyValuePair in
            keyValuePair.value.isEmpty })
    }
    
    public var numConsistentDomainValues: Int {
        variableNameToDomain.reduce(0, { countSoFar, keyValuePair in
            countSoFar + keyValuePair.value.count
        })
    }
    
    public mutating func addDomain(for variable: some Variable, domain: [any Value]) {
        let variableName = variable.name
        variableNameToDomain[variableName] = domain
        variableNameToVariable[variableName] = variable
    }
    
    public func getDomain(for variable: some Variable) -> [any Value] {
        guard let domain = variableNameToDomain[variable.name] else {
            assert(false)
        }
        return domain
    }
}
