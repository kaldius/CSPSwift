/**
 A protocol for all  Unary `Constraint`s on a `TernaryVariable`.
 */
protocol TernaryVariableConstraint: Constraint {
    var ternaryVariable: TernaryVariable { get }
}

extension TernaryVariableConstraint {
    var variables: [any Variable] {
        [ternaryVariable]
    }
}
