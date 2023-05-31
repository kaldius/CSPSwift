/**
 Holds a reference to all the `Variable`s in the CSP.
 Exposes queries required by the solver.
 */
// TODO: TEST
// TODO: rename this to CSP
public struct VariableSet {
    private var variables: [any Variable]
    var setOfVariables: SetOfVariables
    
    /// Required for `orderDomainValues`.
    private let inferenceEngine: InferenceEngine

    /// Stores `VariableDomainState`s used for the undo operation.
    private var domainUndoStack: Stack<VariableDomainState>

    init(variables: [any Variable],
         inferenceEngine: InferenceEngine,
         domainUndoStack: Stack<VariableDomainState>) {
        self.variables = variables
        self.setOfVariables = SetOfVariables(from: variables)
        self.inferenceEngine = inferenceEngine
        self.domainUndoStack = domainUndoStack
    }

    init(variables: [any Variable],
         inferenceEngine: InferenceEngine) {
        self.init(variables: variables,
                  inferenceEngine: inferenceEngine,
                  domainUndoStack: Stack())
        saveCurrentDomainState()
    }
    
    public var isCompletelyAssigned: Bool {
        setOfVariables.isCompletelyAssigned
    }
    
    /// Selects the next Variable to assign using the Minimum Remaining Values heuristic.
    public var nextUnassignedVariable: (any Variable)? {
        setOfVariables.nextUnassignedVariable
    }

    public var latestDomainState: VariableDomainState {
        guard let state = domainUndoStack.peek() else {
            // TODO: throw error
            assert(false)
        }
        return state
    }
    
    /// Orders domain values for a given Variable using the Least Constraining Value heuristic
    /// i.e. Returns an array of Values, sorted by `r` from greatest to smallest, where
    /// `r` is the total number of remaining consistent domain values for all Variables.
    // TODO: optimizations?
    // TODO: restrict return type
    public func orderDomainValues(for variable: some Variable) -> [some Value] {
        var sortables = variable.domain.map({ domainValue in
            let priority = numConsistentDomainValues(ifSetting: variable.name, to: domainValue)
            return SortableValue(value: domainValue,
                                 priority: priority)
        })
        sortables.removeAll(where: { $0.priority == 0 })
        sortables.sort(by: { $0.priority > $1.priority })
        let orderedValues = sortables.map({ $0.value })
        return orderedValues
    }

    /// Given a `VariableDomainState`, save the current state and set the domains
    /// to the ones given in the new state.
    public mutating func updateDomains(using state: VariableDomainState) {
        saveCurrentDomainState()
        setDomains(using: state)
    }

    /// Undo all `Variable`s domains to the previous saved state.
    // TODO: test that undoing infinite times will only stop at inital domain state
    public mutating func revertToPreviousDomainState() {
        guard let prevState = domainUndoStack.peek() else {
            // TODO: throw error
            assert(false)
        }
        if domainUndoStack.count > 1 {
            domainUndoStack.pop()
        }
        setDomains(using: prevState)
    }

    /// Tries setting `variable` to `value`, then counts total number of
    /// consistent domain values for all other variables.
    ///
    /// Returns 0 if setting this value will lead to failure.
    private func numConsistentDomainValues(ifSetting variableName: String,
                                           to value: some Value) -> Int {
        var copiedVariableSet = setOfVariables
        guard let variable = setOfVariables.getVariable(variableName),
              variable.canAssign(to: value) else {
            return 0
        }
        copiedVariableSet.assign(variableName, to: value)
        let newInference = inferenceEngine.makeNewInference(from: copiedVariableSet)
        if newInference.containsEmptyDomain {
            return 0
        }
        return newInference.numConsistentDomainValues
    }

    private mutating func saveCurrentDomainState() {
        domainUndoStack.push(VariableDomainState(from: variables))
    }

    private mutating func setDomains(using state: VariableDomainState) {
        setOfVariables.setAllDomains(using: state)
    }
}

extension VariableSet: Copyable {
    public func copy() -> Self {
        type(of: self).init(variables: variables.copy(),
                            inferenceEngine: inferenceEngine.copy(),
                            domainUndoStack: domainUndoStack.copy())
    }
}
