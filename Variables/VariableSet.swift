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
    
    public init(variables: [any Variable],
                inferenceEngine: InferenceEngine) {
        self.variables = variables
        self.inferenceEngine = inferenceEngine
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
        var sortables = variable.domain.map({ domainValue in
            let priority = numConsistentDomainValues(ifSetting: variable, to: domainValue)
            return Sortable(type(of: domainValue),
                            value: domainValue,
                            priority: priority)
        })
        sortables.removeAll(where: { $0.priority == 0 })
        sortables.sort(by: { $0.priority > $1.priority })
        let orderedValues = sortables.map({ $0.value })
        return orderedValues
    }
    
    /// Tries setting `variable` to `value`, then counts total number of
    /// consistent domain values for all other variables.
    ///
    /// Returns 0 if setting this value will lead to failure.
    private func numConsistentDomainValues(ifSetting variable: some Variable, to value: some Value) -> Int {
        guard variable.canAssign(to: value) else {
            return 0
        }
        variable.assign(to: value)
        let newInference = inferenceEngine.makeNewInference()
        if newInference.leadsToFailure {
            return 0
        }
        return newInference.numConsistentDomainValues
    }
    
    // TODO: CHECK and test
    public func updateDomains(using inference: Inference) {
        for variable in variables {
            let inferredDomain = inference.getDomain(for: variable)
            updateDomain(for: variable, to: inferredDomain)
        }
    }
    
    private func updateDomain(for variable: some Variable, to newDomain: [any Value]) {
        let valueTypeSet = variable.createValueTypeSet(from: newDomain)
        variable.domain = valueTypeSet
    }
    
    public func undoPreviousInferenceUpdate() {
        for variable in variables {
            variable.undoSetDomain()
        }
    }
}
