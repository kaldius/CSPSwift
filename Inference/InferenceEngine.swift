/**
 All Inference Engines used in this CSP solver need to follow this protocol.
 */
public protocol InferenceEngine: Copyable {
    var variables: [any Variable] { get }
    var constraintSet: ConstraintSet { get }

    func makeNewInference() -> VariableDomainState
}
