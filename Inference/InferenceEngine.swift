/**
 All Inference Engines used in this CSP solver need to follow this protocol.
 */
public protocol InferenceEngine {
    var constraintSet: ConstraintSet { get }

    func makeNewInference(from state: SetOfVariables) -> SetOfVariables?
}
