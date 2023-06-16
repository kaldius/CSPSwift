/**
 Holds all the information about the Constraint Satisfaction Problem.
 */
public struct ConstraintSatisfactionProblem {
    var variableSet: VariableSet
    var constraintSet: ConstraintSet

    /// Stores `VariableSet`s used for the undo operation.
    private var stateUndoStack: Stack<VariableSet>

    init(variableSet: VariableSet,
         constraintSet: ConstraintSet,
         stateUndoStack: Stack<VariableSet>) {
        self.variableSet = variableSet
        self.constraintSet = constraintSet
        self.stateUndoStack = stateUndoStack
    }

    /// Automatically applies all `UnaryConstraint`s on `Variable`s, then removes all `UnaryConstraint`s.
    init(variables: [any Variable],
         constraints: [any Constraint]) throws {
        let variableSet = try VariableSet(from: variables)
        var constraintSet = ConstraintSet(constraints)
        let finalVariableSet = try constraintSet.applyUnaryConstraints(to: variableSet)
        constraintSet.removeUnaryConstraints()

        self.init(variableSet: finalVariableSet,
                  constraintSet: constraintSet,
                  stateUndoStack: Stack())
        saveCurrentState()
    }

    public var variablesCompletelyAssigned: Bool {
        variableSet.isCompletelyAssigned
    }

    public var allConstraintsSatisfied: Bool {
        get throws {
            try constraintSet.allSatisfied(state: variableSet)
        }
    }

    public mutating func canAssign(_ variableName: String, to value: some Value) throws -> Bool {
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
    public mutating func update(using state: VariableSet) {
        saveCurrentState()
        setDomains(using: state)
    }

    /// Undo all `Variable`s domains to the previous saved state.
    public mutating func revertToPreviousState() throws {
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
