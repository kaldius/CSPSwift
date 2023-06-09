/**
 Represents a Variable in a CSP.
 
 Reference semantics used here to ensure that any changes to `Variable` are seen by all.
 */
public protocol Variable: Hashable, CustomDebugStringConvertible {
    associatedtype ValueType: Value
    
    var name: String { get }
    
    /// To be used by the computed variable `domain`.
    var internalDomain: Set<ValueType> { get set }

    /// To be used by the computed variable `assignment`.
    var internalAssignment: ValueType? { get set }
}

extension Variable {
    public var domain: Set<ValueType> {
        get {
            if isAssigned {
                guard let unwrappedAssignment = assignment else {
                    // TODO: throw error
                    assert(false)
                }
                return [unwrappedAssignment]
            } else {
                return internalDomain
            }
        }
        set(newDomain) {
            guard canSetDomain(to: newDomain) else {
                // TODO: throw error
                assert(false)
            }
            internalDomain = newDomain
        }
    }
    
    public var assignment: ValueType? {
        get {
            internalAssignment
        }
        set(newAssignment) {
            guard canAssign(to: newAssignment) else {
                // TODO: throw error
                assert(false)
            }
            internalAssignment = newAssignment
        }
    }
    
    /// Returns true if this variable can be set to `newAssignment`,
    /// false otherwise.
    public func canAssign(to newAssignment: some Value) -> Bool {
        let castedNewAssignment = newAssignment as? ValueType
        return canAssign(to: castedNewAssignment)
    }

    public func canAssign(to newAssignment: ValueType?) -> Bool {
        guard let unwrappedNewAssignment = newAssignment else {
            return false
        }
        return assignment == nil && domain.contains(unwrappedNewAssignment)
    }

    /// Another setter, but takes in value of type `any Value` and does the necessary
    /// casting before assignment. If assignment fails, throws error.
    public mutating func assign(to newAssignment: any Value) {
        guard let castedNewAssignment = newAssignment as? ValueType else {
            // TODO: throw error
            assert(false)
        }
        assignment = castedNewAssignment
    }

    public func canSetDomain(to newDomain: [any Value]) -> Bool {
        let newDomainAsValueType = newDomain.compactMap({ $0 as? ValueType })
        guard newDomain.count == newDomainAsValueType.count else {
            return false
        }
        return canSetDomain(to: Set(newDomainAsValueType))
    }

    public func canSetDomain(to newDomain: Set<ValueType>) -> Bool {
        Set(newDomain).isSubset(of: domain)
    }

    // TODO: test
    public mutating func setDomain(to newDomain: [any Value]) {
        domain = createValueTypeSet(from: newDomain)
    }

    /// Takes in an array of `any Value` and casts it to a Set of `ValueType`.
    /// If casting fails for any element, throws error.
    public func createValueTypeSet(from array: [any Value]) -> Set<ValueType> {
        let set = Set(array.compactMap({ $0 as? ValueType }))
        guard array.count == set.count else {
            // TODO: throw error
            assert(false)
        }
        return set
    }
    
    public mutating func unassign() {
        internalAssignment = nil
    }

    public func getSelf() -> Self {
        self
    }

    // MARK: convenience attributes
    public var domainAsArray: [ValueType] {
        Array(domain)
    }
    
    public var domainSize: Int {
        domain.count
    }
    
    public var isAssigned: Bool {
        assignment != nil
    }
    
    public var assignmentAsAnyValue: (any Value)? {
        assignment
    }
    
    public var emptyValueSet: Set<ValueType> {
        Set<ValueType>()
    }
    
    public var emptyValueArray: [ValueType] {
        [ValueType]()
    }
}

extension Variable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
        && lhs.assignment == rhs.assignment
        && lhs.domain == rhs.domain
    }
}

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
        domain.debugDescription
    }
}
