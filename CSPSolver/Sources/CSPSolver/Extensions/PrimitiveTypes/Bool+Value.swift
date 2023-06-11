extension Bool: Value {}

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        // lhs == false && rhs == true
        !lhs && rhs
    }
}
