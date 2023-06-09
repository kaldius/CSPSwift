public struct StringVariable: Variable {
    public var name: String
    public var internalDomain: Set<String>
    public var internalAssignment: String?

    init(name: String, domain: Set<String>) {
        self.init(name: name,
                  internalDomain: domain,
                  internalAssignment: nil)
    }

    init(name: String,
         internalDomain: Set<String>,
         internalAssignment: String?) {
        self.name = name
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
    }
}
