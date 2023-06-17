/**
 `VariableSet` holds all the `Variable`s for a given CSP.
 */
public struct VariableSet {
    private var nameToVariable: [String: any Variable]

    public init(from variables: [any Variable]) throws {
        self.nameToVariable = [:]
        try variables.forEach({ try insert($0) })
    }

    public var variables: [any Variable] {
        Array(nameToVariable.values)
    }

    var unassignedVariables: [any Variable] {
        variables.filter({ !$0.isAssigned })
    }

    var isCompletelyAssigned: Bool {
        variables.allSatisfy({ $0.isAssigned })
    }

    var containsEmptyDomain: Bool {
        variables.contains(where: { $0.domainSize == 0 })
    }

    /// Returns the total number of consistent domain values for all variables.
    var totalDomainValueCount: Int {
        variables.reduce(0, { countSoFar, variable in
            countSoFar + variable.domainSize
        })
    }

    // MARK: insert/extract
    public mutating func insert<Var: Variable>(_ variable: Var) throws {
        guard !contains(variable.name) else {
            throw VariableError.overwritingExistingVariableError(name: variable.name)
        }
        nameToVariable[variable.name] = variable
    }

    func getVariable(_ name: String) -> (any Variable)? {
        nameToVariable[name]
    }

    func getVariable<V: Variable>(_ name: String, type: V.Type) -> V? {
        nameToVariable[name] as? V
    }

    // MARK: Variable assignments
    func isAssigned(_ name: String) throws -> Bool {
        let variable = try extractVariable(named: name)
        return variable.isAssigned
    }

    func canAssign(_ name: String, to assignment: some Value) throws -> Bool {
        guard let variable = nameToVariable[name] else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        return variable.canAssign(to: assignment)
    }

    func getAssignment<V: Variable>(_ name: String, type: V.Type) throws -> V.ValueType? {
        let variable = try extractVariable(named: name)
        if variable.assignment == nil {
            return nil
        }
        guard let assignment = variable.assignment as? V.ValueType else {
            throw VariableError.valueTypeError
        }
        return assignment
    }

    mutating func assign(_ name: String, to assignment: some Value) throws {
        guard contains(name) else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        try nameToVariable[name]?.assign(to: assignment)
    }

    mutating func unassign(_ name: String) throws {
        guard nameToVariable[name] != nil else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        nameToVariable[name]?.unassign()
    }

    // MARK: Variable domains
    mutating func setDomain(for name: String, to newDomain: [any Value]) throws {
        guard contains(name) else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        try nameToVariable[name]?.setDomain(to: newDomain)
    }

    func getDomain(_ name: String) throws -> [any Value] {
        let variable = try extractVariable(named: name)
        return variable.domainAsArray
    }

    func getDomain<V: Variable>(_ name: String, type: V.Type) throws -> [V.ValueType] {
        let domain = try getDomain(name)
        guard let castedDomain = domain as? [V.ValueType] else {
            throw VariableError.valueTypeError
        }
        return castedDomain
    }

    // MARK: private methods
    private func contains(_ name: String) -> Bool {
        nameToVariable[name] != nil
    }

    private func extractVariable(named name: String) throws -> any Variable {
        guard let variable = nameToVariable[name] else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        return variable
    }

}

extension VariableSet: Equatable {
    public static func == (lhs: VariableSet, rhs: VariableSet) -> Bool {
        Set(lhs.nameToVariable.keys) ==  Set(rhs.nameToVariable.keys)
        && Array(lhs.nameToVariable.values).containsSameValues(as: Array(rhs.nameToVariable.values))
    }
}

extension VariableSet: CustomDebugStringConvertible {
    public var debugDescription: String {
        var outputString = ""
        for name in nameToVariable.keys {
            outputString += "[" + name + ": "
            do {
                let domain = try getDomain(name)
                outputString += domain.description
            } catch {
                outputString += "NOT FOUND"
            }
            outputString += "]\n"
        }
        return outputString
    }
}
