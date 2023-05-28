/**
 Represents a state of all `Variable`s domains.
 */
public struct VariableDomainState {
    private var variableNameToDomain: [String: [any Value]]
    private var variableNameToVariable: [String: any Variable]
    
    init() {
        self.variableNameToDomain = [:]
        self.variableNameToVariable = [:]
    }

    init(gettingCurrentStateFrom variables: [any Variable]) {
        self.init()
        for variable in variables {
            variableNameToDomain[variable.name] = variable.domainAsArray
            variableNameToVariable[variable.name] = variable
        }
    }
    
    public var containsEmptyDomain: Bool {
        variableNameToDomain.contains(where: { keyValuePair in
            keyValuePair.value.isEmpty })
    }
    
    /// Returns the total number of consistent domain values for all variables.
    public var numConsistentDomainValues: Int {
        variableNameToDomain.reduce(0, { countSoFar, keyValuePair in
            countSoFar + keyValuePair.value.count
        })
    }
    
    /// Inserts a domain for a given `Variable`. Overwrites if a domain already exists for
    /// that `Variable`.
    public mutating func addDomain(for variable: some Variable, domain: [any Value]) {
        guard variable.canSetDomain(to: domain) else {
            // TODO: throw error
            assert(false)
        }
        let variableName = variable.name
        variableNameToDomain[variableName] = domain
        variableNameToVariable[variableName] = variable
    }
    
    /// Returns the inferred domain for a given `Variable`.
    public func getDomain(for variable: some Variable) -> [any Value] {
        guard let domain = variableNameToDomain[variable.name] else {
            return variable.domainAsArray
        }
        return domain
    }
}
