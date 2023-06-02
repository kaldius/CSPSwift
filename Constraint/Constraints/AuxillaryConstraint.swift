/**
 An`AuxillaryConstraint` is used to ensure that for a given `Variable`, `v`,
 associated with a dual `Variable`, `d`, the assignment for `v` is equal to the
 respective value in the assignment tuple of `d`.
 */
struct AuxillaryConstraint: BinaryConstraint {
    let mainVariableName: String
    let dualVariableName: String

    var variableNames: [String] {
        [mainVariableName, dualVariableName]
    }

    init?(mainVariable: any Variable, dualVariable: TernaryVariable) {
        guard dualVariable.isAssociated(with: mainVariable) else {
            return nil
        }
        self.mainVariableName = mainVariable.name
        self.dualVariableName = dualVariable.name
    }

    func isSatisfied(state: SetOfVariables) -> Bool {
        guard let mainVariable = state.getVariable(mainVariableName),
              let dualVariable = state.getVariable(dualVariableName, type: TernaryVariable.self) else {
            return false
        }
        return dualVariable.assignmentSatisfied(for: mainVariable)
    }

    func isViolated(state: SetOfVariables) -> Bool {
        guard let mainVariable = state.getVariable(mainVariableName),
              let dualVariable = state.getVariable(dualVariableName, type: TernaryVariable.self) else {
            return false
        }
        return dualVariable.assignmentViolated(for: mainVariable)
    }

    func depends(on variableName: String) -> Bool {
        variableName == mainVariableName
        || variableName == dualVariableName
    }
}

extension AuxillaryConstraint: Equatable {
    static func == (lhs: AuxillaryConstraint, rhs: AuxillaryConstraint) -> Bool {
        lhs.mainVariableName.isEqual(rhs.mainVariableName)
        && lhs.dualVariableName.isEqual(rhs.dualVariableName)
    }
}

extension AuxillaryConstraint: Copyable {
    func copy() -> AuxillaryConstraint {
        self
    }
}
