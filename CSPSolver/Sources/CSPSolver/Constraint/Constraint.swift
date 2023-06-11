/**
 All constraints used for this solver must conform to this protocol.
 */
public protocol Constraint: Equatable {
    var variableNames: [String] { get }
    func isSatisfied(state: VariableSet) -> Bool
    func isViolated(state: VariableSet) -> Bool
    func containsAssignedVariable(state: VariableSet) -> Bool
}

extension Constraint {
    func containsAssignedVariable(state: VariableSet) -> Bool {
        variableNames.contains(where: { name in
            let variable = state.getVariable(name)
            return variable?.isAssigned ?? false
        })
    }
}
