
public class StringVariable: Variable {
    public var name: String
    public var domain: Set<String>
    public var assignment: String?
    
    init(name: String, domain: Set<String> = Set()) {
        self.name = name
        self.domain = domain
        self.assignment = nil
    }
}
