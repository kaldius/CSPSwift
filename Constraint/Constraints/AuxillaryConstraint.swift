/**
 An`AuxillaryConstraint` is used to ensure that for a given `Variable`, `v`,
 associated with a dual `Variable`, `d`, the assignment for `v` is equal to the
 respective value in the assignment tuple of `d`.
 */
struct AuxillaryConstraint: Constraint {
    let mainVariable: any Variable
    let dualVariable: any NaryVariable

    var variables: [any Variable] {
        [mainVariable, dualVariable]
    }
    
    init?(mainVariable: any Variable, dualVariable: any NaryVariable) {
        guard dualVariable.isAssociated(with: mainVariable) else {
            return nil
        }
        self.mainVariable = mainVariable
        self.dualVariable = dualVariable
    }
    
    var isSatisfied: Bool {
        dualVariable.assignmentSatisfied(for: mainVariable)
    }
    
    var isViolated: Bool {
        dualVariable.assignmentViolated(for: mainVariable)
    }
}

extension AuxillaryConstraint: Equatable {
    static func == (lhs: AuxillaryConstraint, rhs: AuxillaryConstraint) -> Bool {
        lhs.mainVariable === rhs.mainVariable
        && lhs.dualVariable === rhs.dualVariable
    }
}

extension AuxillaryConstraint: Copyable {
    func copy() -> AuxillaryConstraint {
        self
    }
}
