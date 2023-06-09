extension Array: Comparable where Element: Comparable {
    public static func < (lhs: [Element], rhs: [Element]) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        return (0 ..< lhs.count).allSatisfy({ idx in
            lhs[idx] < rhs[idx]
        })
    }
}
