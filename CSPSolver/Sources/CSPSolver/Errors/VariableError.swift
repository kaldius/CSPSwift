enum VariableError: Error {
    case valueTypeError
    case overwritingExistingVariableError(name: String)
    case nonExistentVariableError(name: String)
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
        }
    }
}
