// TODO: rename to VariableSet
public struct SetOfVariables {
    var nameToVariable: [String: any Variable]

    init(from: [any Variable]) {
        self.nameToVariable = [:]
        for variable in variables {
            insert(variable)
        }
    }

    public var variables: [any Variable] {
        Array(nameToVariable.values)
    }

    public var isCompletelyAssigned: Bool {
        variables.allSatisfy({ $0.isAssigned })
    }

    /// Selects the next Variable to assign using the Minimum Remaining Values heuristic.
    public var nextUnassignedVariable: (any Variable)? {
        // FIXME: is comparator correct?
        variables.min(by: { $0.domainSize > $1.domainSize })
    }

    public var containsEmptyDomain: Bool {
        variables.contains(where: { $0.domainSize == 0 })
    }

    /// Returns the total number of consistent domain values for all variables.
    public var numConsistentDomainValues: Int {
        variables.reduce(0, { countSoFar, variable in
            countSoFar + variable.domainSize
        })
    }

    public mutating func insert(_ variable: some Variable) {
        guard nameToVariable[variable.name] == nil else {
            // TODO: throw error
            assert(false)
        }
        nameToVariable[variable.name] = variable
    }

    public func getVariable(name: String) -> (any Variable)? {
        nameToVariable[name]
    }

    public func exists(_ variableName: String) -> Bool {
        nameToVariable[variableName] != nil
    }

    public func getAssignment(for variableName: String) -> (any Value)? {
        guard exists(variableName) else {
            // TODO: throw error
            assert(false)
        }
        return nameToVariable[variableName]?.assignment
    }

    public mutating func assign(_ variableName: String, to assignment: some Value) {
        guard exists(variableName) else {
            // TODO: throw error
            assert(false)
        }
        nameToVariable[variableName]?.assign(to: assignment)
    }

    public mutating func unassign(_ variableName: String) {
        nameToVariable[variableName]?.unassign()
    }

    public mutating func setDomain(for variableName: String, to newDomain: [any Value]) {
        guard exists(variableName) else {
            // TODO: throw error
            assert(false)
        }
        nameToVariable[variableName]?.setDomain(to: newDomain)
    }

    public mutating func setAllDomains(using state: VariableDomainState) {
        for (name, domain) in state.variableNameToDomain {
            setDomain(for: name, to: domain)
        }
    }

    public func getDomain(variableName: String) -> [any Value] {
        guard let variable = nameToVariable[variableName] else {
            // TODO: throw error
            assert(false)
        }
        return variable.domainAsArray
    }
}
