/**
 A backtracking algorithm that uses an `InferenceEngine` to infer new restrictions on
 `Variable` domains.

 Requires a `NextVariableSelector` to apply a heuristic when selecting the next `Variable` to assign.

 Requires a `DomainValueSorter` to apply a heuristic when selecting the next `Value` to assign
 to a given `Variable`.
 */
public struct CSPSolver {
    private let inferenceEngine: InferenceEngine
    private let nextVariableSelector: any NextVariableSelector
    private let domainValueSorter: any DomainValueSorter

    init(inferenceEngineType: InferenceEngineType,
         nextVariableSelectorType: NextVariableSelectorType,
         domainValueSorterType: DomainValueSorterType) {
        self.inferenceEngine = InferenceEngineFactory.create(inferenceEngineType)
        self.nextVariableSelector = NextVariableSelectorFactory.create(nextVariableSelectorType)
        self.domainValueSorter = DomainValueSorterFactory.create(domainValueSorterType)
    }

    /// Solves a given `ConstraintSatisfactionProblem` in place.
    ///
    /// - Throws: `CSPError.noValidSolutionError` if the CSP does not have a valid solution.
    public func solve(csp: inout ConstraintSatisfactionProblem) throws {
        guard let solvedVariableSet = try backtrack(csp: csp) else {
            throw CSPError.noValidSolutionError
        }
        csp.variableSet = solvedVariableSet
    }

    /// Given a `ConstraintSatisfactionProblem`, returns it in a solved state.
    public func solved(csp: ConstraintSatisfactionProblem) throws -> ConstraintSatisfactionProblem {
        var clonedCsp = csp
        try solve(csp: &clonedCsp)
        return clonedCsp
    }

    /// Returns the `VariableSet` in a solved state if it can be solved,
    /// returns `nil` otherwise.
    func backtrack(csp: ConstraintSatisfactionProblem) throws -> VariableSet? {
        if try csp.variablesCompletelyAssigned && csp.allConstraintsSatisfied {
            return csp.variableSet
        }
        guard let unassignedVariable = nextVariableSelector.nextUnassignedVariable(state: csp.variableSet) else {
            // if there is no nextUnassignedVariable and the constraints are not
            // all satisfied, search has failed
            return nil
        }
        return try testAllValues(for: unassignedVariable, given: csp)
    }

    /// For a given `Variable`, tests every domain `Value` in an order specified
    /// by `domainValueSorter`.
    ///
    /// - Returns: a `VariableSet` of successful assignments if successful, `nil` otherwise.
    private func testAllValues(for variable: some Variable,
                               given csp: ConstraintSatisfactionProblem) throws -> VariableSet? {
        var copiedCsp = csp
        let orderedDomainValues = try domainValueSorter.orderDomainValues(for: variable,
                                                                          state: copiedCsp.variableSet,
                                                                          constraintSet: copiedCsp.constraintSet)
        for domainValue in orderedDomainValues where try copiedCsp.canAssign(variable.name, to: domainValue) {
            guard let successfulState = try testSettingValue(for: variable, to: domainValue, given: copiedCsp) else {
                continue
            }
            return successfulState
        }
        return nil
    }

    /// For a given `Variable` and a given `Value`, tests the assignment and makes an inference.
    ///
    /// - Returns: a `VariableSet` of succesful assignments if successful, `nil` otherwise.
    private func testSettingValue(for variable: some Variable,
                                  to value: some Value,
                                  given csp: ConstraintSatisfactionProblem) throws -> VariableSet? {
        var copiedCsp = csp
        try copiedCsp.variableSet.assign(variable.name, to: value)
        // make new inferences (without setting yet)
        guard let inference = try inferenceEngine.makeNewInference(from: copiedCsp.variableSet,
                                                                   constraintSet: copiedCsp.constraintSet),
              !inference.containsEmptyDomain else {
            // if new inference cannot be made, or inference shows some
            // Variable eventually cannot be assigned, search has failed
            return nil
        }
        // set new inferences
        copiedCsp.update(using: copiedCsp.variableSet)
        let result = try backtrack(csp: copiedCsp)
        guard result != nil else {
            // remove inferences from csp
            return nil
        }
        return result
    }
}
// MARK: old code with revertToPreviousState() (new code does not use this undo, so consider removing)
/*
public struct CSPSolver {
    private let inferenceEngine: InferenceEngine
    private let nextVariableSelector: any NextVariableSelector
    private let domainValueSorter: any DomainValueSorter

    init(inferenceEngine: InferenceEngine,
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
*/
