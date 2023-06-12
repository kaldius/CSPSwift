struct LeastConstrainingValue: DomainValueSorter {
    private let inferenceEngine: InferenceEngine
    private let variableSet: VariableSet
    private let constraintSet: ConstraintSet

    init(inferenceEngine: InferenceEngine, variableSet: VariableSet, constraintSet: ConstraintSet) {
        self.inferenceEngine = inferenceEngine
        self.variableSet = variableSet
        self.constraintSet = constraintSet
    }

    /// Orders domain values for a given Variable using the Least Constraining Value heuristic
    /// i.e. Returns an array of Values, sorted by `r` from greatest to smallest, where
    /// `r` is the total number of remaining consistent domain values for all Variables.
    func orderDomainValues<V: Variable>(for variable: V) -> [V.ValueType] {
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

    /// Tries setting `variable` to `value`, then counts total number of
    /// consistent domain values for all other variables.
    ///
    /// Returns 0 if setting this value will lead to failure.
    private func numConsistentDomainValues(ifSetting variableName: String,
                                           to value: some Value) -> Int {
        var copiedVariableSet = variableSet
        guard let variable = variableSet.getVariable(variableName),
              variable.canAssign(to: value) else {
            return 0
        }
        copiedVariableSet.assign(variableName, to: value)
        guard let newInference = inferenceEngine.makeNewInference(from: copiedVariableSet,
                                                                  constraintSet: constraintSet) else {
            return 0
        }
        return newInference.totalDomainValueCount
    }
}
