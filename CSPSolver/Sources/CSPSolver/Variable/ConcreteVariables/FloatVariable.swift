public struct FloatVariable: Variable {
    public var name: String
    public var _domain: Set<Float>
    public var _assignment: Float?

    init(name: String, domain: Set<Float>) {
        self.init(name: name, internalDomain: domain, internalAssignment: nil)
    }

    init(name: String,
         internalDomain: Set<Float>,
         internalAssignment: Float?) {
        self.name = name
        self._domain = internalDomain
        self._assignment = internalAssignment
    }
}
