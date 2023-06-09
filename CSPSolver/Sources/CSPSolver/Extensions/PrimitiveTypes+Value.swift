extension Int: Value {}

extension Float: Value {
    init?(_ value: any Value) {
        switch value {
        case is Int:
            // swiftlint:disable force_cast
            self.init(value as! Int)
            // swiftlint:enable force_cast
        case is Float:
            // swiftlint:disable force_cast
            self.init(value as! Float)
            // swiftlint:enable force_cast
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
