/**
 A dual `Variable` that represents three `Variable`s.

 Requires three other `AuxillaryConstraint`s to ensure the assignments for all three `Variable`s
 are equal to the respective values in the assignment tuple of the dual `Variable`.
 */
public struct TernaryVariable: NaryVariable {
    public var name: String
    private var _domain: Set<NaryVariableValueType>
    private var _assignment: NaryVariableValueType?

    private var associatedVariables: [any Variable]
    public var associatedVariableNames: [String] {
        associatedVariables.map({ $0.name })
    }

    public init(name: String,
                variableA: any Variable,
                variableB: any Variable,
                variableC: any Variable) {
        self.name = name
        self.associatedVariables = [variableA, variableB, variableC]
        let associatedDomains = Self.getAssociatedDomains(from: associatedVariables)
        self._domain = Self.createInternalDomain(from: associatedDomains)
        self._assignment = nil
    }

    public var domain: Set<NaryVariableValueType> {
        if let unwrappedAssignment = assignment {
            return [unwrappedAssignment]
        } else {
            return _domain
        }
    }

    public var assignment: NaryVariableValueType? {
        _assignment
    }

    public var auxillaryConstraints: [AuxillaryConstraint] {
        associatedVariables.compactMap({ AuxillaryConstraint(mainVariable: $0, dualVariable: self) })
    }

    public mutating func assign(to newAssignment: NaryVariableValueType) throws {
        guard !isAssigned else {
            throw VariableError.overwritingExistingAssignmentError
        }
        guard _domain.contains(newAssignment) else {
            throw VariableError.assignmentNotInDomainError
        }
        _assignment = newAssignment
    }

    public mutating func setDomain(to newDomain: Set<NaryVariableValueType>) throws {
        guard isSubsetOfDomain(newDomain) else {
            throw VariableError.incompatibleDomainError
        }
        _domain = newDomain
    }

    public mutating func unassign() {
        _assignment = nil
    }
}
