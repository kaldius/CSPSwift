public enum CSPError: Error, Equatable {
    case emptyUndoStackError
    case noValidSolutionError
}

extension CSPError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .emptyUndoStackError:
            return "State undo stack is empty"
        case .noValidSolutionError:
            return "No valid solution exists for this CSP"
        }
    }
}
