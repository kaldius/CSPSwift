public protocol BinaryConstraint: Constraint {}

extension BinaryConstraint {
    func depends(on variableName: String) -> Bool {
        variableNames.contains(variableName)
    }

    func variableName(otherThan variableName: String) -> String? {
        if variableName == variableNames[0] {
            return variableNames[1]
        } else if variableName == variableNames[1] {
            return variableNames[0]
        } else {
            return nil
        }
    }
}
