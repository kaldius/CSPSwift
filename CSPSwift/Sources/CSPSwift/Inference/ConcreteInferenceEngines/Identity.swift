/**
 An `InferenceEngine` that does not make any inferences.
 The input and output are identical.
 */
struct Identity: InferenceEngine {
    func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) throws -> VariableSet? {
        return state
    }
}
