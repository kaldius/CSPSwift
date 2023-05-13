//
//  Variables.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public struct VariableSet<T: Value, I: InferenceEngine> where I.T == T {
    private var variables: Set<Variable<T>>
    private let inferenceEngine: I
    // TODO: optimize by making it a real stack?
    private var previousInferences: [Inference<T>]
    
    public init(variables: Set<Variable<T>>,
                inferenceEngine: I) {
        self.variables = variables
        self.inferenceEngine = inferenceEngine
        self.previousInferences = []
    }
    
    public var isCompletelyAssigned: Bool {
        variables.allSatisfy({ $0.assignment != nil })
    }
    
    public var nextUnassignedVariable: Variable<T>? {
        // FIXME: is comparator correct?
        variables.min(by: { $0.domain.count > $1.domain.count })
    }
    
    public var leadsToFailure: Bool {
        previousInferences.last?.leadsToFailure ?? false
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
        let newInference = inferenceEngine.makeNewInference()
        if newInference.leadsToFailure {
            return nil
        }
        return newInference.numConsistentDomainValues
    }
    
    /// Makes new inferences, then saves it in the `previousInferences` stack.
    public mutating func makeNewInferences() {
        let newInference = inferenceEngine.makeNewInference()
        previousInferences.append(newInference)
    }
    
    /// Takes the latest inference in the `previousInferences` stack and sets all variables' domains.
    public func setNewInferences() {
        let latestInference = previousInferences.last
        for variable in variables {
            guard let inferredDomain = latestInference?.getDomain(for: variable) else {
                // should never happen. Consider throwing error?
                assert(false)
            }
            variable.domain = inferredDomain
        }
    }
    
    /// Removes the latest inference from the `previousInferences` stack and
    /// sets all variable domains to the second latest inference.
    public mutating func undoInferences() {
        previousInferences.removeLast()
        setNewInferences()
    }
}
