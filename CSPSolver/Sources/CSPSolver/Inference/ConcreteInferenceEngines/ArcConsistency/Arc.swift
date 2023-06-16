/**
 Represents an Arc for all **Arc Consistency** algorithms.
 */
public struct Arc {
    let variableIName: String
    let variableJName: String
    private let constraintIJ: any BinaryConstraint

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
        guard binaryConstraint.depends(on: variableIName),
              let variableJName = binaryConstraint.variableName(otherThan: variableIName) else {
            return nil
        }
        self.constraintIJ = binaryConstraint
        self.variableIName = variableIName
        self.variableJName = variableJName
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

    /// Revise the domain for `variableI` to only include values that have at least one
    /// supporting `variableJ` value.
    ///
    /// - Returns: an array representing the revised domain for `variableI`, or nil if no revision occured.
    public func revise(state: VariableSet) throws -> [any Value]? {
        guard try !state.isAssigned(variableIName) else {
            return nil
        }
        let variableIDomain = try state.getDomain(variableIName)
        var variableIDomainCopy = variableIDomain
        for iDomainValue in variableIDomain where try canBeRemoved(iDomainValue, state: state) {
            // TODO: optimize?
            variableIDomainCopy.removeAll(where: { $0.isEqual(iDomainValue) })
        }
        if variableIDomainCopy.isEqual(variableIDomain) {
            return nil
        } else {
            return variableIDomainCopy
        }
    }

    /// Checks if the given `iDomainValue` can be removed from the domain of `variableI`.
    private func canBeRemoved(_ iDomainValue: any Value, state: VariableSet) throws -> Bool {
        var copiedState = state
        try copiedState.assign(variableIName, to: iDomainValue)
        if try copiedState.isAssigned(variableJName) {
            return try !constraintIJ.isSatisfied(state: copiedState)
        }
        let variableJDomain = try state.getDomain(variableJName)
        return try !containsSatisfactoryJValue(domain: variableJDomain, state: copiedState)
    }

    /// Checks if the provided `domain` contains an assignment for `variableJ` such that
    /// `constraintIJ` is satisfied.
    private func containsSatisfactoryJValue(domain: [any Value], state: VariableSet) throws -> Bool {
        var copiedState = state
        // look for a domainValue that satisfies the constraint
        return try domain.contains(where: { jDomainValue in
            try copiedState.assign(variableJName, to: jDomainValue)
            let satisfied = try constraintIJ.isSatisfied(state: copiedState)
            try copiedState.unassign(variableJName)
            return satisfied
        })
    }
}
