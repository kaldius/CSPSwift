/**
 All Inference Engines used in this CSP solver need to follow this protocol.
 */

public protocol InferenceEngine {
    var variables: [any Variable] { get }
    var constraints: Constraints { get }
    
    func makeNewInference() -> Inference
}
