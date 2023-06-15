/**
 `VariableSet` holds all the `Variable`s for a given CSP.
 */
public struct VariableSet {
    private var nameToVariable: [String: any Variable]

    init(from variables: [any Variable]) throws {
        self.nameToVariable = [:]
        try variables.forEach({ try insert($0) })
    }

    public var variables: [any Variable] {
        Array(nameToVariable.values)
    }

    public var unassignedVariables: [any Variable] {
        variables.filter({ !$0.isAssigned })
    }

    public var isCompletelyAssigned: Bool {
        variables.allSatisfy({ $0.isAssigned })
    }

    public var containsEmptyDomain: Bool {
        variables.contains(where: { $0.domainSize == 0 })
    }

    /// Returns the total number of consistent domain values for all variables.
    public var totalDomainValueCount: Int {
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

    public func getVariable(_ name: String) -> (any Variable)? {
        nameToVariable[name]
    }

    public func getVariable<V: Variable>(_ name: String, type: V.Type) -> V? {
        nameToVariable[name] as? V
    }

    // MARK: Variable assignments
    public func isAssigned(_ name: String) throws -> Bool {
        let variable = try extractVariable(named: name)
        return variable.isAssigned
    }

    public func canAssign(_ name: String, to assignment: some Value) throws -> Bool {
        guard let variable = nameToVariable[name] else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        return variable.canAssign(to: assignment)
    }

    public func getAssignment<V: Variable>(_ name: String, type: V.Type) throws -> V.ValueType? {
        let variable = try extractVariable(named: name)
        if variable.assignment == nil {
            return nil
        }
        guard let assignment = variable.assignment as? V.ValueType else {
            throw VariableError.valueTypeError
        }
        return assignment
    }

    public mutating func assign(_ name: String, to assignment: some Value) throws {
        guard contains(name) else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        try nameToVariable[name]?.assign(to: assignment)
    }

    public mutating func unassign(_ name: String) {
        nameToVariable[name]?.unassign()
    }

    // MARK: Variable domains
    public mutating func setDomain(for name: String, to newDomain: [any Value]) throws {
        guard contains(name) else {
            throw VariableError.nonExistentVariableError(name: name)
        }
        try nameToVariable[name]?.setDomain(to: newDomain)
    }

    public func getDomain(_ name: String) throws -> [any Value] {
        let variable = try extractVariable(named: name)
        return variable.domainAsArray
    }

    public func getDomain<V: Variable>(_ name: String, type: V.Type) throws -> [V.ValueType] {
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
