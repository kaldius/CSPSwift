/**
 All constraints used for this solver must conform to this protocol.
 */
public protocol Constraint: Equatable {
    var variableNames: [String] { get }
    func isSatisfied(state: VariableSet) throws -> Bool
    func isViolated(state: VariableSet) throws -> Bool
}

extension Constraint {
    func containsAssignedVariable(state: VariableSet) -> Bool {
        variableNames.contains(where: { name in
            let variable = state.getVariable(name)
            return variable?.isAssigned ?? false
        })
    }
}

extension [any Constraint] {
    func isEqual(_ other: [any Constraint]) -> Bool {
        var equal = self.count == other.count
        for idx in 0 ..< self.count {
            equal = equal && self[idx].isEqual(other[idx])
        }
        return equal
    }

    func containsSameValues(as array: [any Constraint]) -> Bool {
        var correct = self.count == array.count
        for value in self {
            correct = correct && array.contains(where: { $0.isEqual(value) })
        }
        return correct
    }
}
