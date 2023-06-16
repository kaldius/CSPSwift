enum VariableError: Error, Equatable {
    case valueTypeError
    case overwritingExistingVariableError(name: String)
    case nonExistentVariableError(name: String)
    case incompatibleDomainError
    case overwritingExistingAssignmentError
    case assignmentNotInDomainError
}

extension VariableError: CustomStringConvertible {
    var description: String {
        switch self {
        case .valueTypeError:
            return "Unable to cast value to Variable.ValueType"
        case .overwritingExistingVariableError(let variableName):
            return "Cannot overwrite a variable of name: \(variableName), which already exists in the VariableSet"
        case .nonExistentVariableError(let variableName):
            return "Variable of name: \(variableName) does not exist in the VariableSet"
        case .incompatibleDomainError:
            return "New domain is not a subset of old domain"
        case .overwritingExistingAssignmentError:
            return "Unassign variable before attempting to assign a new value"
        case .assignmentNotInDomainError:
            return "Variables can only be assigned to values in their current domain"
        }
    }
}
