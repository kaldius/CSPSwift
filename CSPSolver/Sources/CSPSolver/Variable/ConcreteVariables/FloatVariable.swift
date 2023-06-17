public struct FloatVariable: Variable {
    public var name: String
    private var _domain: Set<Float>
    private var _assignment: Float?

    public init(name: String, domain: Set<Float>) {
        self.name = name
        self._domain = domain
        self._assignment = nil
    }

    public var domain: Set<Float> {
        if let unwrappedAssignment = assignment {
            return [unwrappedAssignment]
        } else {
            return _domain
        }
    }

    public var assignment: Float? {
        _assignment
    }

    public mutating func assign(to newAssignment: Float) {
        _assignment = newAssignment
    }

    public mutating func setDomain(to newDomain: Set<Float>) {
        _domain = newDomain
    }

    public mutating func unassign() {
        _assignment = nil
    }
}
