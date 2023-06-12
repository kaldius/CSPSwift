/**
 A protocol for all Inference Engines used in this CSPSolver.
 */
public protocol InferenceEngine {
    func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) -> VariableSet?
}
