public struct IntVariable: Variable {
    public var name: String
    public var _domain: Set<Int>
    public var _assignment: Int?

    init(name: String, domain: Set<Int>) {
        self.init(name: name,
                  internalDomain: domain,
                  internalAssignment: nil)
    }

    init(name: String,
         internalDomain: Set<Int>,
         internalAssignment: Int?) {
        self.name = name
        self._domain = internalDomain
        self._assignment = internalAssignment
    }
}
