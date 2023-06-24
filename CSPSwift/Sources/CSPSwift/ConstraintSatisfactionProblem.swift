/**
 Holds all the information about the Constraint Satisfaction Problem.
 */
public struct ConstraintSatisfactionProblem {
    public var variableSet: VariableSet
    private(set) var constraintSet: ConstraintSet

    /// Stores `VariableSet`s used for the undo operation.
    private var stateUndoStack: Stack<VariableSet>

    /// Automatically applies all `UnaryConstraint`s on `Variable`s, then removes all `UnaryConstraint`s.
    public init(variables: [any Variable],
                constraints: [any Constraint]) throws {
        let tempVariableSet = try VariableSet(from: variables)
        var tempConstraintSet = ConstraintSet(constraints)
        let finalVariableSet = try tempConstraintSet.applyUnaryConstraints(to: tempVariableSet)
        tempConstraintSet.removeUnaryConstraints()

        self.variableSet = finalVariableSet
        self.constraintSet = tempConstraintSet
        self.stateUndoStack = Stack()

        saveCurrentState()
    }

    var variablesCompletelyAssigned: Bool {
        variableSet.isCompletelyAssigned
    }

    var allConstraintsSatisfied: Bool {
        get throws {
            try constraintSet.allSatisfied(state: variableSet)
        }
    }

    mutating func canAssign(_ variableName: String, to value: some Value) throws -> Bool {
        guard try variableSet.canAssign(variableName, to: value) else {
            return false
        }
        try variableSet.assign(variableName, to: value)
        let anyViolated = try constraintSet.anyViolated(state: variableSet)
        try variableSet.unassign(variableName)
        return !anyViolated
    }

    /// Given a `VariableSet`, save the current state and set the domains
    /// to the ones given in the new state.
    mutating func update(using state: VariableSet) {
        saveCurrentState()
        setDomains(using: state)
    }

    /// Undo all `Variable`s domains to the previous saved state.
    mutating func revertToPreviousState() throws {
        guard let prevState = stateUndoStack.peek() else {
            throw CSPError.emptyUndoStackError
        }
        if stateUndoStack.count > 1 {
            stateUndoStack.pop()
        }
        setDomains(using: prevState)
    }

    private mutating func saveCurrentState() {
        stateUndoStack.push(variableSet)
    }

    private mutating func setDomains(using state: VariableSet) {
        variableSet = state
    }
}
