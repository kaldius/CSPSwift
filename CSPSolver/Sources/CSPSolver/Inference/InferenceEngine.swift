/**
 A protocol for all Inference Engines used in this CSPSolver.
 */
public protocol InferenceEngine {
    func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) -> VariableSet?
}

struct InferenceEngineFactory {
    static func create(_ type: InferenceEngineType) -> any InferenceEngine {
        switch type {
        case .ac3:
            return ArcConsistency3()
        }
    }
}
