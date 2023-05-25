
public class IntVariable: Variable {
    public var name: String
    public var internalDomain: Set<Int>
    public var domainUndoStack: Stack<Set<Int>>
    public var internalAssignment: Int?
    public var constraints: [any Constraint]
    
    init(name: String, domain: Set<Int> = Set()) {
        self.name = name
        self.internalDomain = domain
        self.domainUndoStack = Stack()
        self.internalAssignment = nil
        self.constraints = []
    }
}
