/**
 Represents a state of all `Variable`s domains.
 */
// TODO: TEST
// TODO: compare use of VDS vs just copying variableSets
public struct VariableDomainState {
    public var variableNameToDomain: [String: [any Value]]
    private var variableNameToVariable: [String: any Variable]

    init() {
        self.variableNameToDomain = [:]
        self.variableNameToVariable = [:]
    }

    init(from variables: [any Variable]) {
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

    public mutating func addDomain(for variableName: String, domain: [any Value]) {
        guard let variable = variableNameToVariable[variableName] else {
            assert(false)
        }
        addDomain(for: variable, domain: domain)
    }
    
    /// Returns the inferred domain for a given `Variable`.
    public func getDomain(for variable: some Variable) -> [any Value]? {
        guard let domain = variableNameToDomain[variable.name] else {
            return nil
        }
        return domain
    }

    public func getDomain(for variableName: String) -> [any Value]? {
        guard let domain = variableNameToDomain[variableName] else {
            return nil
        }
        return domain
    }
}

extension VariableDomainState: Equatable {
    public static func == (lhs: VariableDomainState, rhs: VariableDomainState) -> Bool {
        lhs.variableNameToDomain.keys == rhs.variableNameToDomain.keys
        && Array(lhs.variableNameToDomain.values).containsSameValues(as: Array(rhs.variableNameToDomain.values))
        && lhs.variableNameToVariable.keys == rhs.variableNameToVariable.keys
        && Array(lhs.variableNameToVariable.values).containsSameValues(as: Array(rhs.variableNameToVariable.values))
    }
}
