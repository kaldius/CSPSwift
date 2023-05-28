public class StringVariable: Variable {
    public var name: String
    public var internalDomain: Set<String>
    public var internalAssignment: String?
    public var constraints: [any Constraint]

    init(name: String, domain: Set<String>) {
        self.name = name
        self.internalDomain = domain
        self.internalAssignment = nil
        self.constraints = []
    }
}
