/**
 Represents the result returned by an `InferenceEngine`.
 */

public struct Inference {
    private var variableNameToDomain: [String: [any Value]]
    private var variableNameToVariable: [String: any Variable]
    
    init() {
        self.variableNameToDomain = [:]
        self.variableNameToVariable = [:]
    }
    
    public var leadsToFailure: Bool {
        variableNameToDomain.contains(where: { keyValuePair in
            keyValuePair.value.isEmpty })
    }
    
    /// Returns the total number of consistent domain values for all variables
    public var numConsistentDomainValues: Int {
        variableNameToDomain.reduce(0, { countSoFar, keyValuePair in
            countSoFar + keyValuePair.value.count
        })
    }
    
    /// Inserts a domain for a given `Variable`
    public mutating func addDomain(for variable: some Variable, domain: [any Value]) {
        guard variable.canSetDomain(to: domain) else {
            // TODO: throw error
            assert(false)
        }
        let variableName = variable.name
        variableNameToDomain[variableName] = domain
        variableNameToVariable[variableName] = variable
    }
    
    /// Returns the inferred domain for a given `Variable`
    public func getDomain(for variable: some Variable) -> [any Value]? {
        getDomain(for: variable.name)
    }
    
    /// Returns the inferred domain for a given `Variable`'s name
    public func getDomain(for variableName: String) -> [any Value]? {
        variableNameToDomain[variableName]
    }
}
