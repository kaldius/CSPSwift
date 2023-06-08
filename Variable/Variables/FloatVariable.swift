public struct FloatVariable: Variable {
    public var name: String
    public var internalDomain: Set<Float>
    public var internalAssignment: Float?

    init(name: String, domain: Set<Float>) {
        self.init(name: name, internalDomain: domain, internalAssignment: nil)
    }

    init(name: String,
         internalDomain: Set<Float>,
         internalAssignment: Float?) {
        self.name = name
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
    }
}
