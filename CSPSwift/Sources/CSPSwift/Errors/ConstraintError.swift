enum ConstraintError: Error {
    // TODO: this error not used, consider using it
    case ternaryVariableContainsNonAddable
}

extension ConstraintError: CustomStringConvertible {
    var description: String {
        switch self {
        case .ternaryVariableContainsNonAddable:
            return "TernaryVariable values are not all Addable"
        }
    }
}
