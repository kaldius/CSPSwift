/**
 A Unary `Constraint` on a `TernaryVariable`.

 Applies a constraint of the following form on the `Variables` associated
 with the `TernaryVariable`:

 `(scaleA * variableA) + (scaleB * variableB) + (scaleC * variableC) + add == 0`

 Note: this constraint assumes all `Variables` associated with the
 `TernaryVariable` hold some number type.
 */
struct LinearCombinationConstraint: TernaryVariableConstraint {
    let ternaryVariable: TernaryVariable
    let scaleA: Float
    let scaleB: Float
    let scaleC: Float
    let add: Float

    init(_ ternaryVariable: TernaryVariable,
         scaleA: Float,
         scaleB: Float,
         scaleC: Float,
         add: Float) {
        self.ternaryVariable = ternaryVariable
        self.scaleA = scaleA
        self.scaleB = scaleB
        self.scaleC = scaleC
        self.add = add
    }

    var isSatisfied: Bool {
        guard let assignment: NaryVariableValueType = ternaryVariable.assignment,
              let variableA = Float(assignment[0]),
              let variableB = Float(assignment[1]),
              let variableC = Float(assignment[2]) else {
            return false
        }
        let scaledVariableA = scaleA * variableA
        let scaledVariableB = scaleB * variableB
        let scaledVariableC = scaleC * variableC
        return scaledVariableA + scaledVariableB + scaledVariableC + add == 0
    }

    var isViolated: Bool {
        guard let assignment: NaryVariableValueType = ternaryVariable.assignment,
              let variableA = Float(assignment[0]),
              let variableB = Float(assignment[1]),
              let variableC = Float(assignment[2]) else {
            return false
        }
        let scaledVariableA = scaleA * variableA
        let scaledVariableB = scaleB * variableB
        let scaledVariableC = scaleC * variableC
        return scaledVariableA + scaledVariableB + scaledVariableC + add != 0
    }
}
