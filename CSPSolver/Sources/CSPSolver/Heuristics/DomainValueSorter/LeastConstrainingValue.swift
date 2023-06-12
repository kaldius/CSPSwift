struct LeastConstrainingValue: DomainValueSorter {
    private let inferenceEngine: InferenceEngine

    init(inferenceEngine: InferenceEngine) {
        self.inferenceEngine = inferenceEngine
    }

    /// Orders domain values for a given Variable using the Least Constraining Value heuristic
    /// i.e. Returns an array of Values, sorted by `r` from greatest to smallest, where
    /// `r` is the total number of remaining consistent domain values for all Variables.
    func orderDomainValues<V: Variable>(for variable: V,
                                        state: VariableSet,
                                        constraintSet: ConstraintSet) -> [V.ValueType] {
        var sortables = variable.domain.map({ domainValue in
            let priority = numConsistentDomainValues(ifSetting: variable.name,
                                                     to: domainValue,
                                                     state: state,
                                                     constraintSet: constraintSet)
            return SortableValue(value: domainValue,
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
    private func numConsistentDomainValues(ifSetting variableName: String,
                                           to value: some Value,
                                           state: VariableSet,
                                           constraintSet: ConstraintSet) -> Int {
        var copiedState = state
        guard let variable = state.getVariable(variableName),
              variable.canAssign(to: value) else {
            return 0
        }
        copiedState.assign(variableName, to: value)
        guard let newInference = inferenceEngine.makeNewInference(from: copiedState,
                                                                  constraintSet: constraintSet) else {
            return 0
        }
        return newInference.totalDomainValueCount
    }
}
