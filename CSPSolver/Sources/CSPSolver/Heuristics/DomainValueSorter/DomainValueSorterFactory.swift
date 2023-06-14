/**
 A factory that creates `DomainValueSorter`s.
 */
struct DomainValueSorterFactory {
    static func create(_ type: DomainValueSorterType) -> any DomainValueSorter {
        switch type {
        case .leastConstrainingValue_ac3:
            let ac3 = InferenceEngineFactory.create(.ac3)
            return LeastConstrainingValue(inferenceEngine: ac3)
        case .leastConstrainingValue_forwardChecking:
            let forwardChecking = InferenceEngineFactory.create(.forwardChecking)
            return LeastConstrainingValue(inferenceEngine: forwardChecking)
        case .random:
            return RandomDVS()
        }
    }
}
