public struct Arc {
    let variableIName: String
    let variableJName: String
    let constraintIJ: any BinaryConstraint

    init(from binaryConstraint: any BinaryConstraint, reverse: Bool = false) {
        self.constraintIJ = binaryConstraint
        if reverse {
            self.variableIName = binaryConstraint.variableNames[1]
            self.variableJName = binaryConstraint.variableNames[0]
        } else {
            self.variableIName = binaryConstraint.variableNames[0]
            self.variableJName = binaryConstraint.variableNames[1]
        }
    }

    init?(from binaryConstraint: any BinaryConstraint, variableIName: String) {
        guard binaryConstraint.depends(on: variableIName) else {
            return nil
        }
        self.constraintIJ = binaryConstraint
        self.variableIName = variableIName
        self.variableJName = binaryConstraint.variableName(otherThan: variableIName)
    }

    init?(from constraint: any Constraint, reverse: Bool = false) {
        guard let binaryConstraint = constraint as? any BinaryConstraint else {
            return nil
        }
        self.init(from: binaryConstraint, reverse: reverse)
    }

    public func contains(_ variableName: String) -> Bool {
        variableName == variableIName || variableName == variableJName
    }

    public func revise(state: SetOfVariables) -> [any Value]? {
        guard !state.isAssigned(variableIName) else {
            return nil
        }
        let variableIDomain = state.getDomain(variableIName)
        var variableIDomainCopy = variableIDomain
        for iDomainValue in variableIDomain {
            var copiedState = state
            // assign I value
            copiedState.assign(variableIName, to: iDomainValue)
            var allJValuesViolateConstraint = false
            if copiedState.isAssigned(variableJName) {
                allJValuesViolateConstraint = constraintIJ.isViolated(state: copiedState)
            } else {
                let variableJDomain = state.getDomain(variableJName)
                // check if all values in J domain violate constraint
                allJValuesViolateConstraint = variableJDomain.allSatisfy({ jDomainValue in
                    copiedState.assign(variableJName, to: jDomainValue)
                    let violated = constraintIJ.isViolated(state: copiedState)
                    copiedState.unassign(variableJName)
                    return violated
                })
            }
            if allJValuesViolateConstraint {
                variableIDomainCopy.removeAll(where: { $0.isEqual(iDomainValue) })
            }
        }
        if variableIDomainCopy.isEqual(variableIDomain) {
            return nil
        } else {
            return variableIDomainCopy
        }
    }
}
