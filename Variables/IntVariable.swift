
public class IntVariable: Variable {
    public var name: String
    public var domain: Set<Int>
    public var assignment: Int?
    
    init(name: String, domain: Set<Int> = Set()) {
        self.name = name
        self.domain = domain
        self.assignment = nil
    }
}
