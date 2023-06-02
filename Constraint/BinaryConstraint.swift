public protocol BinaryConstraint: Constraint {
    func depends(on variableName: String) -> Bool
}
