public struct StringVariable: Variable {
    public var name: String
    private var _domain: Set<String>
    private var _assignment: String?

    init(name: String, domain: Set<String>) {
        self.name = name
        self._domain = domain
        self._assignment = nil
    }

    public var domain: Set<String> {
        if let unwrappedAssignment = assignment {
            return [unwrappedAssignment]
        } else {
            return _domain
        }
    }

    public var assignment: String? {
        _assignment
    }

    public mutating func assign(to newAssignment: String) {
        _assignment = newAssignment
    }

    public mutating func setDomain(to newDomain: Set<String>) {
        _domain = newDomain
    }

    public mutating func unassign() {
        _assignment = nil
    }
}
