/**
 A protocol followed by all dual `Variable`s which encode N variables at once.
 */
public protocol NaryVariable: Variable {
    associatedtype ValueType = NaryVariableValueType

    var associatedVariableNames: [String] { get }
    var assignment: NaryVariableValueType? { get set }
    var internalAssignment: NaryVariableValueType? { get set }
    var domain: Set<NaryVariableValueType> { get set }
    var internalDomain: Set<NaryVariableValueType> { get set }
}

extension NaryVariable {
    func isAssociated(with variable: any Variable) -> Bool {
        associatedVariableNames.contains(where: { $0 == variable.name })
    }

    func isAssociated(with variableName: String) -> Bool {
        associatedVariableNames.contains(where: { $0 == variableName })
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

    static func getAssociatedDomains(from associatedVariables: [any Variable]) -> [[any Value]] {
        associatedVariables.map({ $0.domainAsArray })
    }

    private func getIndex(of variable: any Variable) -> Int? {
        associatedVariableNames.firstIndex(of: variable.name)
    }
}
