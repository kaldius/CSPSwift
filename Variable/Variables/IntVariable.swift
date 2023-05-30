public struct IntVariable: Variable {
    public var name: String
    public var internalDomain: Set<Int>
    public var internalAssignment: Int?

    init(name: String, domain: Set<Int>) {
        self.init(name: name,
                  internalDomain: domain,
                  internalAssignment: nil)
    }

    init(name: String,
         internalDomain: Set<Int>,
         internalAssignment: Int?) {
        self.name = name
        self.internalDomain = internalDomain
        self.internalAssignment = internalAssignment
    }
}

extension IntVariable: Copyable {
    public func copy() -> Self {
        type(of: self).init(name: name,
                            internalDomain: internalDomain,
                            internalAssignment: internalAssignment)
    }
}
