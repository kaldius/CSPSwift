/**
 All Inference Engines used in this CSP solver need to follow this protocol.
 */
public protocol InferenceEngine {
    func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) -> VariableSet?
}
