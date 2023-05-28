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

    init(name: String, variableA: any Variable, variableB: any Variable, variableC: any Variable) {
        self.name = name
        self.associatedVariables = [variableA, variableB, variableC]
        self.internalAssignment = nil
        self.constraints = []

        // need to initialize to the empty Set first before `associatedDomains` can be accessed
        self.internalDomain = Set()
        self.internalDomain = Self.createInternalDomain(from: associatedDomains)
    }
}
