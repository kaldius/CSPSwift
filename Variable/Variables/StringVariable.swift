public class StringVariable: Variable {
    public var name: String
    public var internalDomain: Set<String>
    public var internalAssignment: String?
    public var constraints: [any Constraint]

    convenience init(name: String, domain: Set<String>) {
        self.init(name: name,
                  internalDomain: domain,
                  internalAssignment: nil,
                  constraints: [])
    }

    required init(name: String,
                  internalDomain: Set<String>,
                  internalAssignment: String?,
                  constraints: [any Constraint]) {
        self.name = name
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
        self.constraints = constraints
    }
}

extension StringVariable: Copyable {
    public func copy() -> Self {
        return type(of: self).init(name: name,
                                   internalDomain: internalDomain,
                                   internalAssignment: internalAssignment,
                                   constraints: constraints)
    }
}
