/**
 All constraints used for this solver must conform to this protocol.
 */
public protocol Constraint: Equatable, Copyable {
    var variables: [any Variable] { get }
    var isSatisfied: Bool { get }
    var isViolated: Bool { get }
}

extension Constraint {
    var containsAssignedVariable: Bool {
        variables.contains(where: { $0.isAssigned })
    }

    func addSelfToAllVariables() {
        variables.forEach({ $0.add(constraint: self) })
    }
}

extension [Constraint] {
    func copy() -> [any Constraint] {
        self.map({ $0.copy() })
    }
}
