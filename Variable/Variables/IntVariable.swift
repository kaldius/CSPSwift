public class IntVariable: Variable {
    public var name: String
    public var internalDomain: Set<Int>
    public var internalAssignment: Int?
    public var constraints: [any Constraint]

    convenience init(name: String, domain: Set<Int>) {
        self.init(name: name,
                  internalDomain: domain,
                  internalAssignment: nil,
                  constraints: [])
    }

    required init(name: String,
                  internalDomain: Set<Int>,
                  internalAssignment: Int?,
                  constraints: [any Constraint]) {
        self.name = name
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
        self.constraints = constraints
    }
}

extension IntVariable: Copyable {
    public func copy() -> Self {
        return type(of: self).init(name: name,
                                   internalDomain: internalDomain,
                                   internalAssignment: internalAssignment,
                                   constraints: constraints)
    }
}
