extension Array: Comparable where Element: Comparable {
    public static func < (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        return (0 ..< lhs.count).reduce(true, { result, idx in
            result && lhs[idx] < rhs[idx]
        })
    }
}
