enum CSPError: Error, Equatable {
    case emptyUndoStackError
}

extension CSPError: CustomStringConvertible {
    var description: String {
        switch self {
        case .emptyUndoStackError:
            return "State undo stack is empty"
        }
    }
}
