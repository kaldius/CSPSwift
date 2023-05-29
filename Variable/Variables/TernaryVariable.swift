/**
 A dual `Variable` that represents three `Variable`s.

 Requires three other `AuxillaryConstraint`s to ensure the assignments for all three `Variable`s
 are equal to the respective values in the assignment tuple of the dual `Variable`.
 */
class TernaryVariable: NaryVariable {
    var name: String
    var internalDomain: Set<NaryVariableValueType>
    var internalAssignment: NaryVariableValueType?
    var constraints: [any Constraint]

    var associatedVariables: [any Variable]

    convenience init(name: String,
         variableA: any Variable,
         variableB: any Variable,
         variableC: any Variable) {
        let associatedVariables = [variableA, variableB, variableC]
        let associatedDomains = Self.getAssociatedDomains(from: associatedVariables)
        let domain = Self.createInternalDomain(from: associatedDomains)
        self.init(name: name,
                  associatedVariables: associatedVariables,
                  internalDomain: domain,
                  internalAssignment: nil,
                  constraints: [])
    }

    required init(name: String,
                  associatedVariables: [any Variable],
                  internalDomain: Set<NaryVariableValueType>,
                  internalAssignment: NaryVariableValueType?,
                  constraints: [any Constraint]) {
        self.name = name
        self.associatedVariables = associatedVariables
        self.internalDomain = internalDomain
        self.internalAssignment = nil
        self.constraints = []
    }
}

extension TernaryVariable: Copyable {
    public func copy() -> Self {
        return type(of: self).init(name: name,
                                   associatedVariables: associatedVariables.copy(),
                                   internalDomain: internalDomain,
                                   internalAssignment: internalAssignment,
                                   constraints: constraints)
    }
}

