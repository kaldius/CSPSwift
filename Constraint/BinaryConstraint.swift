public protocol BinaryConstraint: Constraint {
    func depends(on variableName: String) -> Bool
}

extension BinaryConstraint {
    func variableName(otherThan variableName: String) -> String {
        if variableName == variableNames[0] {
            return variableNames[1]
        } else {
            return variableNames[0]
        }
    }
}
