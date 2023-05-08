//
//  Variables.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public struct VariableSet<T: Value, I: InferenceEngine> {
    private var variables: Set<Variable<T>>
    private let inferenceEngine: I
    private var currentInference: Inference<T>
    
    public init(variables: Set<Variable<T>>,
                inferenceEngine: I) {
        self.variables = variables
        self.inferenceEngine = inferenceEngine
        self.currentInference = Inference()
    }
    
    public var isCompletelyAssigned: Bool {
        variables.allSatisfy({ $0.assignment != nil })
    }
    
    public var nextUnassignedVariable: Variable<T>? {
        // FIXME: is comparator correct?
        variables.min(by: { $0.domain.count > $1.domain.count })
    }
    
    public var leadsToFailure: Bool {
        currentInference.leadsToFailure
    }
    
    // TODO: optimizations?
    public func orderDomainValues(for variable: Variable<T>) -> [T] {
        var priorityValuePairs: [(Int, T)] = variable.domain.compactMap({ domainValue in
            // larger priority = better
            guard let priority = numConsistentDomainValues(ifSetting: variable, to: domainValue) else {
                return nil
            }
            return (priority, domainValue)
        })
        priorityValuePairs.sort(by: { $0.0 > $1.0 })
        let orderedValues = priorityValuePairs.map({ $1 })
        return orderedValues
    }
    
    private func numConsistentDomainValues(ifSetting variable: Variable<T>, to value: T) -> Int? {
        variable.assignment = value
        let newInference = inferenceEngine.makeNewInferences()
        if newInference.leadsToFailure {
            return nil
        }
        return newInference.numConsistentDomainValues
    }
    
    public func setNew(domains: [Variable<T>: [T]]) {
        // could be [String: [T]] also idk...
        // TODO: set all variables to the new domains provided, but maintain undo stack
    }
    
    public func undoLastChange() {
        // TODO: revert all variables' domains to the previous state
    }
    
    public func makeNewInferences() {
        // TODO: call inferenceEngine.makeNewInferences() then store and save undo stack
    }
    
    public func setNewInferences() {
        // TODO: set all variables' domains to the currentInferences' values
    }
    
    public func undoInferences() {
        // TODO: set al variables' domains to the previous set of domains
    }
}
