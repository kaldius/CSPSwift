/**
 A protocol for all  Unary `Constraint`s on a `TernaryVariable`.
 */
public protocol TernaryVariableConstraint: UnaryConstraint {
    var variableName: String { get }

    init(_ ternaryVariable: TernaryVariable,
         scaleA: Float,
         scaleB: Float,
         scaleC: Float,
         add: Float)
}

extension TernaryVariableConstraint {
    public var variableNames: [String] {
        [variableName]
    }
}
