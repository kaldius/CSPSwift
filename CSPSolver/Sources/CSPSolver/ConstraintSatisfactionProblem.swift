/**
 Holds a reference to all the `Variable`s in the CSP.
 Exposes queries required by the solver.
 */
// TODO: TEST
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
         constraints: [any Constraint]) {
        let variableSet = VariableSet(from: variables)
        var constraintSet = ConstraintSet(allConstraints: constraints)
        let finalVariableSet = constraintSet.applyUnaryConstraints(to: variableSet)
        constraintSet.removeUnaryConstraints()

        self.init(variableSet: finalVariableSet,
                  constraintSet: constraintSet,
                  stateUndoStack: Stack())
        saveCurrentState()
    }

    public var isCompletelyAssigned: Bool {
        variableSet.isCompletelyAssigned
    }

    /// Selects the next Variable to assign using the Minimum Remaining Values heuristic.
    // TODO: pull out as a separate protocol to allow flexible heuristics
    public var nextUnassignedVariable: (any Variable)? {
        variableSet.nextUnassignedVariable
    }

    // TODO: delete?
    public var latestState: VariableSet {
        guard let state = stateUndoStack.peek() else {
            // TODO: throw error
            assert(false)
        }
        return state
    }

    /// Given a `VariableSet`, save the current state and set the domains
    /// to the ones given in the new state.
    public mutating func update(using state: VariableSet) {
        saveCurrentState()
        setDomains(using: state)
    }

    /// Undo all `Variable`s domains to the previous saved state.
    // TODO: test that undoing infinite times will only stop at inital domain state
    public mutating func revertToPreviousState() {
        guard let prevState = stateUndoStack.peek() else {
            // TODO: throw error
            assert(false)
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
