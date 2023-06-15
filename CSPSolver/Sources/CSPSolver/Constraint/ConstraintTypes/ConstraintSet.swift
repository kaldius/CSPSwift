/**
 `ConstraintSet` holds all the `Constraint`s for a given CSP.
 */
public struct ConstraintSet {
    private(set) var allConstraints: [any Constraint]

    public init(_ allConstraints: [any Constraint] = []) {
        self.allConstraints = allConstraints
    }

    var unaryConstraints: [any UnaryConstraint] {
        allConstraints.compactMap({ $0 as? any UnaryConstraint })
    }

    var binaryConstraints: [any BinaryConstraint] {
        allConstraints.compactMap({ $0 as? any BinaryConstraint })
    }

    public mutating func add(constraint: any Constraint) {
        allConstraints.append(constraint)
    }

    public func allSatisfied(state: VariableSet) throws -> Bool {
        try allConstraints.allSatisfy({ try $0.isSatisfied(state: state) })
    }

    public func anyViolated(state: VariableSet) throws -> Bool {
        try allConstraints.contains(where: { try $0.isViolated(state: state) })
    }

    /// Applies all `UnaryConstraint`s to the given `state` and returns a new
    /// `VariableSet` where all `Variable`s domains have been constrained.
    public func applyUnaryConstraints(to state: VariableSet) throws -> VariableSet {
        return try unaryConstraints.reduce(state, { try $1.restrictDomain(state: $0) })
    }

    public mutating func removeUnaryConstraints() {
        allConstraints = allConstraints.filter({ !($0 is any UnaryConstraint) })
    }
}
