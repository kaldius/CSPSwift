/**
 A protocol for all Inference Engines used in this CSPSolver.
 */
public protocol InferenceEngine {
    /// Given a `VariableSet` and a `ConstraintSet`, applies an inference algorithm.
    ///
    /// - Returns: a `VariableSet` containing the same`Variables` with their domains
    /// reduced by the inference algorithm.
    func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) throws -> VariableSet?
}
