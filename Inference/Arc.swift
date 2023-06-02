public struct Arc {
    let variableIName: String
    let variableJName: String
    let constraintIJ: any BinaryConstraint

    init(from binaryConstraint: any BinaryConstraint) {
        self.constraintIJ = binaryConstraint
        self.variableIName = constraintIJ.variableNames[0]
        self.variableJName = constraintIJ.variableNames[1]
    }

    init?(from constraint: any Constraint) {
        guard let binaryConstraint = constraint as? any BinaryConstraint else {
            return nil
        }
        self.init(from: binaryConstraint)
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
            let variableJDomain = state.getDomain(variableJName)
            // check if all values in J domain violate constraint
            let allJValuesViolateConstraint = variableJDomain.allSatisfy({ jDomainValue in
                copiedState.assign(variableJName, to: jDomainValue)
                let violated = constraintIJ.isViolated(state: copiedState)
                copiedState.unassign(variableJName)
                return violated
            })
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
