public struct CSPSolver {
    private let inferenceEngine: InferenceEngine
    private let nextVariableSelector: any NextVariableSelector
    private let domainValueSorter: any DomainValueSorter

    init(inferenceEngine: InferenceEngine,
         // TODO: turn these into enums, should not have user inputting the constraintset into the domainValueSorter
         nextVariableSelector: any NextVariableSelector,
         domainValueSorter: any DomainValueSorter) {
        self.inferenceEngine = inferenceEngine
        self.nextVariableSelector = nextVariableSelector
        self.domainValueSorter = domainValueSorter
    }

    /// Returns the `VariableSet` in a solved state if it can be solved,
    /// returns `nil` otherwise.
    public func backtrack(csp: ConstraintSatisfactionProblem) -> VariableSet? {
        if csp.variablesCompletelyAssigned && csp.allConstraintsSatisfied {
            return csp.variableSet
        }
        guard let unassignedVariable = nextVariableSelector.nextUnassignedVariable(state: csp.variableSet) else {
            // if there is no nextUnassignedVariable and the constraints are not
            // all satisfied, search has failed
            return nil
        }
        var copiedCsp = csp
        for domainValue in domainValueSorter.orderDomainValues(for: unassignedVariable,
                                                               state: copiedCsp.variableSet,
                                                               constraintSet: csp.constraintSet) {
            if copiedCsp.canAssign(unassignedVariable.name, to: domainValue) {
                copiedCsp.variableSet.assign(unassignedVariable.name, to: domainValue)
                // copiedVariableSet.assign(unassignedVariable.name, to: domainValue)
                // make new inferences (without setting yet)
                guard let state = inferenceEngine.makeNewInference(from: copiedCsp.variableSet,
                                                                   constraintSet: copiedCsp.constraintSet) else {
                    // if new inference cannot be made, search has failed
                    copiedCsp.variableSet.unassign(unassignedVariable.name)
                    continue
                }
                if !state.containsEmptyDomain {
                    // set new inferences
                    copiedCsp.update(using: copiedCsp.variableSet)
                    let result = backtrack(csp: copiedCsp)
                    if result != nil {
                        return result
                    }
                    // remove inferences from csp
                    copiedCsp.revertToPreviousState()
                }
                let result = backtrack(csp: copiedCsp)
                if result != nil {
                    return result
                }
                copiedCsp.variableSet.unassign(unassignedVariable.name)
            }
        }
        return nil
    }
}
