/**
 All constraints used for this solver must conform to this protocol.
 */
public protocol Constraint: Equatable, Copyable {
    var variableNames: [String] { get }
    func isSatisfied(state: SetOfVariables) -> Bool
    func isViolated(state: SetOfVariables) -> Bool
    func containsAssignedVariable(state: SetOfVariables) -> Bool
}

extension Constraint {
    func containsAssignedVariable(state: SetOfVariables) -> Bool {
        variableNames.contains(where: { name in
            let variable = state.getVariable(name)
            return variable?.isAssigned ?? false
        })
    }
}

extension [Constraint] {
    func copy() -> [any Constraint] {
        self.map({ $0.copy() })
    }
}
