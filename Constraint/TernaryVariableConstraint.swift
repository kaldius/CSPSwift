/**
 A protocol for all  Unary `Constraint`s on a `TernaryVariable`.
 */
protocol TernaryVariableConstraint: Constraint {
    var ternaryVariableName: String { get }
}

extension TernaryVariableConstraint {
    var variableNames: [String] {
        [ternaryVariableName]
    }
}
