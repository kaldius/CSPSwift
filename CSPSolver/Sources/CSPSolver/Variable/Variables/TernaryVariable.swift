/**
 A dual `Variable` that represents three `Variable`s.

 Requires three other `AuxillaryConstraint`s to ensure the assignments for all three `Variable`s
 are equal to the respective values in the assignment tuple of the dual `Variable`.
 */
struct TernaryVariable: NaryVariable {
    var name: String
    var internalDomain: Set<NaryVariableValueType>
    var internalAssignment: NaryVariableValueType?

    var associatedVariableNames: [String]

    init(name: String,
         variableA: any Variable,
         variableB: any Variable,
         variableC: any Variable) {
        let associatedVariables = [variableA, variableB, variableC]
        let associatedVariableNames = associatedVariables.map { $0.name }
        let associatedDomains = Self.getAssociatedDomains(from: associatedVariables)
        let domain = Self.createInternalDomain(from: associatedDomains)
        self.init(name: name,
                  associatedVariableNames: associatedVariableNames,
                  internalDomain: domain,
                  internalAssignment: nil)
    }

    init(name: String,
         associatedVariableNames: [String],
         internalDomain: Set<NaryVariableValueType>,
         internalAssignment: NaryVariableValueType?) {
        self.name = name
        self.associatedVariableNames = associatedVariableNames
        self.internalDomain = internalDomain
        self.internalAssignment = nil
    }
}
