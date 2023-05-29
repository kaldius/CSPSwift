public class FloatVariable: Variable {
    public var name: String
    public var internalDomain: Set<Float>
    public var internalAssignment: Float?
    public var constraints: [any Constraint]

    convenience init(name: String, domain: Set<Float>) {
        self.init(name: name, internalDomain: domain, internalAssignment: nil, constraints: [])
    }

    required init(name: String,
                  internalDomain: Set<Float>,
                  internalAssignment: Float?,
                  constraints: [any Constraint]) {
        self.name = name
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
        self.constraints = constraints
    }
}

extension FloatVariable: Copyable {
    public func copy() -> Self {
        type(of: self).init(name: name,
                            internalDomain: internalDomain,
                            internalAssignment: internalAssignment,
                            constraints: constraints)
    }
}
