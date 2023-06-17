/**
 Represents a Variable in a CSP.
 */
public protocol Variable: Hashable, CustomDebugStringConvertible {
    associatedtype ValueType: Value

    var name: String { get }
    var domain: Set<ValueType> { get }
    var assignment: ValueType? { get }

    mutating func assign(to newAssignment: ValueType) throws
    mutating func setDomain(to newDomain: Set<ValueType>) throws
    mutating func unassign()
}

extension Variable {
    /// Returns true if assignment can be set to `newAssignment`, false otherwise.
    /// Note: this method takes in any type that conforms to `Value`.
    func canAssign(to newAssignment: some Value) -> Bool {
        guard let castedNewAssignment = newAssignment as? ValueType else {
            return false
        }
        return !isAssigned && domain.contains(castedNewAssignment)
    }

    /// Sets the `Variable` assignment to `newAssignment`.
    /// Note: this method takes in any type that conforms to `Value`.
    ///
    /// - Throws: `VariableError.valueTypeError` if casting fails
    mutating func assign(to newAssignment: any Value) throws {
        guard let castedNewAssignment = newAssignment as? ValueType else {
            throw VariableError.valueTypeError
        }
        try assign(to: castedNewAssignment)
    }

    /// Returns true if domain can be set to `newDomain`, false otherwise.
    /// Note: this method takes in an **array** of any type that conforms to `Value`.
    func canSetDomain(to newDomain: [any Value]) -> Bool {
        let newDomainAsValueType = newDomain.compactMap({ $0 as? ValueType })
        guard newDomain.count == newDomainAsValueType.count else {
            // casting failed at some point in compactMap
            return false
        }
        return isSubsetOfDomain(Set(newDomainAsValueType))
    }

    /// Sets the `Variable` domain to `newDomain`.
    /// Note: this method takes in an **array** of any type that conforms to `Value`.
    mutating func setDomain(to newDomain: [any Value]) throws {
        try setDomain(to: try createValueTypeSet(from: newDomain))
    }

    /// Takes in an array of `any Value` and casts it to a Set of `ValueType`.
    /// If casting fails for any element, throws error.
    ///
    /// - Throws: `VariableError.valueTypeError` if casting fails
    func createValueTypeSet(from array: [any Value]) throws -> Set<ValueType> {
        let set = Set(array.compactMap({ $0 as? ValueType }))
        guard array.count == set.count else {
            // casting failed at some point in compactMap
            throw VariableError.valueTypeError
        }
        return set
    }

    public func isSubsetOfDomain(_ newDomain: Set<ValueType>) -> Bool {
        Set(newDomain).isSubset(of: domain)
    }

    // MARK: convenience attributes
    var domainAsArray: [ValueType] {
        Array(domain)
    }

    public var domainSize: Int {
        domain.count
    }

    public var isAssigned: Bool {
        assignment != nil
    }
}

// Equatable
extension Variable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
        && lhs.assignment == rhs.assignment
        && lhs.domain == rhs.domain
    }
}

// Hashable
extension Variable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Variable {
    func isEqual(_ other: any Variable) -> Bool {
        guard let other = other as? Self else {
            return other.isExactlyEqual(self)
        }
        return self == other
    }

    private func isExactlyEqual(_ other: any Variable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}

extension [any Variable] {
    func isEqual(_ other: [any Variable]) -> Bool {
        var equal = self.count == other.count
        for idx in 0 ..< self.count {
            equal = equal && self[idx].isEqual(other[idx])
        }
        return equal
    }

    func containsSameValues(as array: [any Variable]) -> Bool {
        var correct = self.count == array.count
        for value in self {
            correct = correct && array.contains(where: { $0.isEqual(value) })
        }
        return correct
    }
}

extension Variable {
    public var debugDescription: String {
        "[" + name + ": " + domain.debugDescription + "]"
    }
}
