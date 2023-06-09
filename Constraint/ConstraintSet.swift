/**
 `ConstraintSet` holds all the constraints for a given CSP.
 */
public struct ConstraintSet {
    private(set) var allConstraints: [any Constraint]

    var unaryConstraints: [any UnaryConstraint] {
        allConstraints.compactMap({ $0 as? any UnaryConstraint })
    }
    
    public init(allConstraints: [any Constraint] = []) {
        self.allConstraints = allConstraints
    }
    
    public mutating func add(constraint: any Constraint) {
        allConstraints.append(constraint)
    }

    public func allSatisfied(state: SetOfVariables) -> Bool {
        allConstraints.allSatisfy({ $0.isSatisfied(state: state) })
    }

    // TODO: test
    public func applyUnaryConstraints(to state: SetOfVariables) -> SetOfVariables {
        // unaryConstraints.reduce(state, { $1.restrictDomain(state: $0) })
        var copiedState = state
        for constraint in unaryConstraints {
            copiedState = constraint.restrictDomain(state: copiedState)
        }
        return copiedState
    }

    // TODO: test
    public mutating func removeUnaryConstraints() {
        allConstraints = allConstraints.filter({ !($0 is any UnaryConstraint) })
    }
}
