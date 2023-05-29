/**
 Holds a reference to all the `Variable`s in the CSP.
 Exposes queries required by the solver.
 */
// TODO: TEST
public class VariableSet {
    private var variables: [any Variable]
    
    /// Required for `orderDomainValues`.
    private let inferenceEngine: InferenceEngine

    /// Stores `VariableDomainState`s used for the undo operation.
    private var domainUndoStack: Stack<VariableDomainState>

    public init(variables: [any Variable],
                inferenceEngine: InferenceEngine) {
        self.variables = variables
        self.inferenceEngine = inferenceEngine
        self.domainUndoStack = Stack()
        saveCurrentDomainState()
    }
    
    public var isCompletelyAssigned: Bool {
        variables.allSatisfy({ $0.isAssigned })
    }
    
    /// Selects the next Variable to assign using the Minimum Remaining Values heuristic.
    public var nextUnassignedVariable: (any Variable)? {
        // FIXME: is comparator correct?
        variables.min(by: { $0.domainSize > $1.domainSize })
    }
    
    /// Orders domain values for a given Variable using the Least Constraining Value heuristic
    /// i.e. Returns an array of Values, sorted by `r` from greatest to smallest, where
    /// `r` is the total number of remaining consistent domain values for all Variables.
    // TODO: optimizations?
    public func orderDomainValues(for variable: some Variable) -> [some Value] {
        var sortables = variable.domain.map({ domainValue in
            let priority = numConsistentDomainValues(ifSetting: variable, to: domainValue)
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
    public func updateDomains(using state: VariableDomainState) {
        saveCurrentDomainState()
        setDomains(using: state)
    }

    /// Undo all `Variable`s domains to the previous saved state.
    public func revertToPreviousDomainState() {
        guard let prevState = domainUndoStack.pop() else {
            return
        }
        setDomains(using: prevState)
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
        if newInference.containsEmptyDomain {
            return 0
        }
        return newInference.numConsistentDomainValues
    }

    private func saveCurrentDomainState() {
        domainUndoStack.push(VariableDomainState(from: variables))
    }

    private func setDomains(using state: VariableDomainState) {
        for variable in variables {
            let newDomain = state.getDomain(for: variable)
            setDomain(for: variable, to: newDomain)
        }
    }

    private func setDomain(for variable: some Variable, to newDomain: [any Value]) {
        let valueTypeSet = variable.createValueTypeSet(from: newDomain)
        variable.domain = valueTypeSet
    }
}
