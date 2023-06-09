/**
 A protocol for all  Unary `Constraint`s on a `TernaryVariable`.
 */
protocol TernaryVariableConstraint: UnaryConstraint {
    var variableName: String { get }
}

extension TernaryVariableConstraint {
    var variableNames: [String] {
        [variableName]
    }
}
