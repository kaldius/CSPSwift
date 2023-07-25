// TODO: test
public struct TernaryVariableConstraintBuilder {
    public static func create(constraintType: TernaryVariableConstraintType,
                              variableA: any Variable,
                              variableB: any Variable,
                              variableC: any Variable,
                              scaleA: Float,
                              scaleB: Float,
                              scaleC: Float,
                              add: Float = 0) -> (ternaryVariable: TernaryVariable,
                                                  constraints: [any Constraint]) {
        let name = variableA.name + "+" + variableB.name + "+" + variableC.name
        let ternaryVariable = TernaryVariable(name: name,
                                              variableA: variableA,
                                              variableB: variableB,
                                              variableC: variableC)
        var constraints: [any Constraint] = ternaryVariable.auxillaryConstraints
        switch constraintType {
        case .linearCombinationConstraint:
            let newConstraint = LinearCombinationConstraint(ternaryVariable,
                                                            scaleA: scaleA,
                                                            scaleB: scaleB,
                                                            scaleC: scaleC,
                                                            add: add)
            constraints.append(newConstraint)
        }

        return (ternaryVariable, constraints)
    }
}
