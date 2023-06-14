/**
 A factory that creates `InferenceEngine`s.
 */
struct InferenceEngineFactory {
    static func create(_ type: InferenceEngineType) -> any InferenceEngine {
        switch type {
        case .ac3:
            return ArcConsistency3()
        case .forwardChecking:
            return ForwardChecking()
        }
    }
}
