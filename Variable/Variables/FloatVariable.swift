public class FloatVariable: Variable {
    public var name: String
    public var internalDomain: Set<Float>
    public var internalAssignment: Float?
    public var constraints: [any Constraint]

    init(name: String, domain: Set<Float>) {
        self.name = name
        self.internalDomain = domain
        self.internalAssignment = nil
        self.constraints = []
    }
}
