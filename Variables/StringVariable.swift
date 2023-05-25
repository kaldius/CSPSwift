public class StringVariable: Variable {
    public var name: String
    public var internalDomain: Set<String>
    public var domainUndoStack: Stack<Set<String>>
    public var internalAssignment: String?
    public var constraints: [any Constraint]
    
    init(name: String, domain: Set<String> = Set()) {
        self.name = name
        self.internalDomain = domain
        self.domainUndoStack = Stack()
        self.internalAssignment = nil
        self.constraints = []
    }
}
