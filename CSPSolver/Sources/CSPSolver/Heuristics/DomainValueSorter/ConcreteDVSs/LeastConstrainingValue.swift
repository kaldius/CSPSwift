/**
 Sorts domain values using the **Least Constraining Value** heuristic.
 i.e. sorts by total number of remaining consistent domain values for all `Variable`s.

 In order to infer remaining consistent domain values, an `InferenceEngine` must be provided.

 Note: The `ForwardChecking` seems to be faster than `ArcConsistency3` for the
 `InferenceEngine` used here. Although AC-3 shrinks domains more, its slow runtime
 likely negates its benefits.
 */
struct LeastConstrainingValue: DomainValueSorter {
    private let inferenceEngine: InferenceEngine

    init(inferenceEngine: InferenceEngine) {
        self.inferenceEngine = inferenceEngine
    }

    /// Sorts domain values by total number of remaining consistent domain values for all `Variable`s.
    public func orderDomainValues<V: Variable>(for variable: V,
                                               state: VariableSet,
                                               constraintSet: ConstraintSet) throws -> [V.ValueType] {
        var sortables = try variable.domain.map({ domainValue in
            let priority = try numConsistentDomainValues(ifSetting: variable.name,
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
                                           constraintSet: ConstraintSet) throws -> Int {
        var copiedState = state
        guard let variable = state.getVariable(variableName),
              variable.canAssign(to: value) else {
            return 0
        }
        try copiedState.assign(variableName, to: value)
        guard let newInference = try inferenceEngine.makeNewInference(from: copiedState,
                                                                  constraintSet: constraintSet) else {
            return 0
        }
        return newInference.totalDomainValueCount
    }
}
