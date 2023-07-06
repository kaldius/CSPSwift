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
                                           constraint: any TernaryVariableConstraint) {
        let name = variableA.name + "+" + variableB.name + "+" + variableC.name
        let ternaryVariable = TernaryVariable(name: name,
                                              variableA: variableA,
                                              variableB: variableB,
                                              variableC: variableC)
        var constraint: (any TernaryVariableConstraint)? = nil

        switch constraintType {
        case .linearCombinationConstraint:
            constraint = LinearCombinationConstraint(ternaryVariable,
                                                     scaleA: scaleA,
                                                     scaleB: scaleB,
                                                     scaleC: scaleC,
                                                     add: add)
        }

        return (ternaryVariable, constraint!)
    }
}
