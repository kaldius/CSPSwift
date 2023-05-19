//
//  Variables.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//

import Foundation

public struct VariableSet {
    private var variables: [any Variable]
    // FIXME: should inferenceEngine be here or at solver level?
    private let inferenceEngine: InferenceEngine
    private var previousInferences: [Inference]
    
    public init(variables: [any Variable],
                inferenceEngine: InferenceEngine) {
        self.variables = variables
        self.inferenceEngine = inferenceEngine
        self.previousInferences = []
    }
    
    public var isCompletelyAssigned: Bool {
        variables.allSatisfy({ $0.isAssigned })
    }
    
    public var nextUnassignedVariable: (any Variable)? {
        // FIXME: is comparator correct?
        variables.min(by: { $0.domainSize > $1.domainSize })
    }
    
    // TODO: optimizations?
    public func orderDomainValues(for variable: some Variable) -> [some Value] {
        var sortables = variable.domain.map({ Sortable(type(of: $0), value: $0) })
        sortables.sort(by: { $0.priority > $1.priority })
        let orderedValues = sortables.map({ $0.value })
        return orderedValues
    }
    
    private func getPriorityValuePair<T>(for variable: some Variable, domainValue: T) -> (Int, T)? where T: Value {
        guard let priority = numConsistentDomainValues(ifSetting: variable, to: domainValue) else {
            return nil
        }
        return (priority, domainValue)
    }
    
    private func numConsistentDomainValues(ifSetting variable: some Variable, to value: some Value) -> Int? {
        guard variable.canAssign(to: value) else {
            return nil
        }
        variable.assign(to: value)
        let newInference = inferenceEngine.makeNewInference()
        if newInference.leadsToFailure {
            return nil
        }
        return newInference.numConsistentDomainValues
    }
    
    // FIXME: should inferenceEngine be here or at solver level?
    /// Makes new inferences, then saves it in the `previousInferences` stack.
    public mutating func makeNewInferences() {
        let newInference = inferenceEngine.makeNewInference()
        previousInferences.append(newInference)
    }
    
    // FIXME: should inferenceEngine be here or at solver level?
    /// Takes the latest inference in the `previousInferences` stack and sets all variables' domains.
    public func setNewInferences() {
        let latestInference = previousInferences.last
        for variable in variables {
            guard let inferredDomain = latestInference?.getDomain(for: variable.name) else {
                // should never happen. Consider throwing error?
                assert(false)
            }
            variable.setDomain(newDomain: inferredDomain)
        }
    }
    
    // FIXME: should inferenceEngine be here or at solver level?
    /// Removes the latest inference from the `previousInferences` stack and
    /// sets all variable domains to the second latest inference.
    public mutating func undoInferences() {
        previousInferences.removeLast()
        setNewInferences()
    }
}
