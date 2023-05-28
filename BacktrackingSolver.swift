public struct BacktrackingSolver {
    let inferenceEngine: InferenceEngine
    
    init(inferenceEngine: InferenceEngine) {
        self.inferenceEngine = inferenceEngine
    }
    
    /// Returns the solvable in a solved state if it can be solved,
    /// returns `nil` otherwise.
    public func backtrack(variableSet: VariableSet, constraints: ConstraintCollection) -> Bool {
        if variableSet.isCompletelyAssigned && constraints.allSatisfied {
            return true
        }
        guard let unassignedVariable = variableSet.nextUnassignedVariable else {
            // if there is no nextUnassignedVariable and the constraints are not
            // all satisfied, search has failed
            return false
        }
        for domainValue in variableSet.orderDomainValues(for: unassignedVariable) {
            if unassignedVariable.canAssign(to: domainValue) {
                unassignedVariable.assign(to: domainValue)
                // make new inferences (without setting yet)
                let state = inferenceEngine.makeNewInference()
                if !state.containsEmptyDomain {
                    // set new inferences
                    variableSet.updateDomains(using: state)
                    let result = backtrack(variableSet: variableSet, constraints: constraints)
                    if result {
                        return true
                    }
                    // remove inferences from csp
                    variableSet.revertToPreviousDomainState()
                }
                unassignedVariable.unassign()
            }
        }
        return false
    }
}
