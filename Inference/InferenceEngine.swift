/**
 All Inference Engines used in this CSP solver need to follow this protocol.
 */
public protocol InferenceEngine {
    var variables: [any Variable] { get }
    var constraintCollection: ConstraintCollection { get }

    func makeNewInference() -> VariableDomainState
}
