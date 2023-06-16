public struct StringVariable: Variable {
    public var name: String
    private var _domain: Set<String>
    private var _assignment: String?

    init(name: String, domain: Set<String>) {
        self.name = name
        self._domain = domain
        self._assignment = nil
    }

    public var domain: Set<String> {
        if let unwrappedAssignment = assignment {
            return [unwrappedAssignment]
        } else {
            return _domain
        }
    }

    public var assignment: String? {
        _assignment
    }

    public mutating func assign(to newAssignment: String) throws {
        guard !isAssigned else {
            throw VariableError.overwritingExistingAssignmentError
        }
        guard _domain.contains(newAssignment) else {
            throw VariableError.assignmentNotInDomainError
        }
        _assignment = newAssignment
    }

    public mutating func setDomain(to newDomain: Set<String>) throws {
        guard isSubsetOfDomain(newDomain) else {
            throw VariableError.incompatibleDomainError
        }
        _domain = newDomain
    }

    public mutating func unassign() {
        _assignment = nil
    }
}
