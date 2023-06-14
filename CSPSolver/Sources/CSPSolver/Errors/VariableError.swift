enum VariableError: Error {
    case valueTypeError
    case overwritingExistingVariableError(name: String)

    var errorMsg: String {
        switch self {
        case .valueTypeError:
            return "Value provided is not of type Variable.ValueType"
        case.overwritingExistingVariableError(let variableName):
            return "Attempting to overwrite a variable of name: \(variableName), which already exists"
        }
    }
}
