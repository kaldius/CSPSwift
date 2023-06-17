public struct IntVariable: Variable {
    public var name: String
    private var _domain: Set<Int>
    private var _assignment: Int?

    public init(name: String, domain: Set<Int>) {
        self.name = name
        self._domain = domain
        self._assignment = nil
    }

    public var domain: Set<Int> {
        if let unwrappedAssignment = assignment {
            return [unwrappedAssignment]
        } else {
            return _domain
        }
    }

    public var assignment: Int? {
        _assignment
    }

    public mutating func assign(to newAssignment: Int) throws {
        guard !isAssigned else {
            throw VariableError.overwritingExistingAssignmentError
        }
        guard _domain.contains(newAssignment) else {
            throw VariableError.assignmentNotInDomainError
        }
        _assignment = newAssignment
    }

    public mutating func setDomain(to newDomain: Set<Int>) throws {
        guard isSubsetOfDomain(newDomain) else {
            throw VariableError.incompatibleDomainError
        }
        _domain = newDomain
    }

    public mutating func unassign() {
        _assignment = nil
    }
}
