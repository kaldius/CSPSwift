/**
 A protocol followed by all dual `Variable`s which encode N variables at once.
 */

protocol NaryVariable: Variable {
    associatedtype ValueType = NaryVariableValueType

    var associatedVariables: [any Variable] { get }
    var assignment: NaryVariableValueType? { get set }
    var internalAssignment: NaryVariableValueType? { get set }
    var domain: Set<NaryVariableValueType> { get set }
    var internalDomain: Set<NaryVariableValueType> { get set }
}

extension NaryVariable {
    /// Returns an array of domains for each variable in `associatedVariables` where
    /// the order of the domains matches the order in `associatedVariables`.
    var associatedDomains: [[any Value]] {
        associatedVariables.map({ $0.domainAsArray })
    }

    func isAssociated(with variable: any Variable) -> Bool {
        associatedVariables.contains(where: { $0 === variable})
    }

    /// Checks that `variable`'s assignment is equal to self's assignment at
    /// corresponding index.
    func assignmentSatisfied(for variable: some Variable) -> Bool {
        guard let varAssignment = variable.assignment,
              let idx = getIndex(of: variable),
              let assignmentAtIdx = assignment?[idx] else {
            return false
        }
        return assignmentAtIdx.isEqual(varAssignment)
    }

    /// Checks that `variable`'s assignment is **not** equal to self's assignment at
    /// corresponding index.
    func assignmentViolated(for variable: some Variable) -> Bool {
        guard let varAssignment = variable.assignment,
              let idx = getIndex(of: variable),
              let assignmentAtIdx = assignment?[idx] else {
            return false
        }
        return !assignmentAtIdx.isEqual(varAssignment)
    }

    /// Initializes `internalDomain`, setting it to all possible assignments from `associatedDomains`.
    static func createInternalDomain(from associatedDomains: [[any Value]]) -> Set<NaryVariableValueType> {
        let possibleAssignments = Array<any Value>.possibleAssignments(domains: associatedDomains)
        return Set(possibleAssignments.map({ NaryVariableValueType(value: $0) }))
    }

    private func getIndex(of variable: any Variable) -> Int? {
        associatedVariables.firstIndex(where: { $0 === variable })
    }
}
