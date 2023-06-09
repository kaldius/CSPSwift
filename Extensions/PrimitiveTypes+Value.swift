extension Int: Value {}

extension Float: Value {
    init?(_ value: any Value) {
        switch value {
        case is Int:
            self.init(value as! Int)
        case is Float:
            self.init(value as! Float)
        default:
            return nil
        }
    }
}

extension Bool: Value {}

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        // lhs == false && rhs == true
        !lhs && rhs
    }
}

extension String: Value {}
