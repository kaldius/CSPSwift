// TODO: rename to VariableSet
public struct SetOfVariables {
    var nameToVariable: [String: any Variable]

    init(from variables: [any Variable]) {
        self.nameToVariable = [:]
        variables.forEach({ insert($0) })
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

    public mutating func insert<Var: Variable>(_ variable: Var) {
        guard nameToVariable[variable.name] == nil else {
            // TODO: throw error
            assert(false)
        }
        nameToVariable[variable.name] = variable
    }

    public func getVariable(_ name: String) -> (any Variable)? {
        nameToVariable[name]
    }

    public func getVariable<V: Variable>(_ name: String, type: V.Type) -> V? {
        nameToVariable[name] as? V
    }

    public func exists(_ name: String) -> Bool {
        nameToVariable[name] != nil
    }

    public func isAssigned(_ name: String) -> Bool {
        guard let variable = nameToVariable[name] else {
            // TODO: throw error
            assert(false)
        }
        return variable.isAssigned
    }

    public func getAssignment<V: Variable>(_ name: String, type: V.Type) -> V.ValueType? {
        guard exists(name) else {
            // TODO: throw error
            assert(false)
        }
        return nameToVariable[name]?.assignment as? V.ValueType
    }

    public mutating func assign(_ name: String, to assignment: some Value) {
        guard exists(name) else {
            // TODO: throw error
            assert(false)
        }
        nameToVariable[name]?.assign(to: assignment)
    }

    public mutating func unassign(_ name: String) {
        nameToVariable[name]?.unassign()
    }

    public mutating func setDomain(for name: String, to newDomain: [any Value]) {
        guard exists(name) else {
            // TODO: throw error
            assert(false)
        }
        nameToVariable[name]?.setDomain(to: newDomain)
    }

    public mutating func setAllDomains(using state: VariableDomainState) {
        for (name, domain) in state.variableNameToDomain {
            setDomain(for: name, to: domain)
        }
    }

    public func getDomain(_ name: String) -> [any Value] {
        guard let variable = nameToVariable[name] else {
            // TODO: throw error
            assert(false)
        }
        return variable.domainAsArray
    }

    public func getDomain<V: Variable>(_ name: String, type: V.Type) -> [V.ValueType] {
        guard let variable = nameToVariable[name] else {
            // TODO: throw error
            assert(false)
        }
        // TODO: fix implicit unwrap
        return variable.domainAsArray as! [V.ValueType]
    }
}
