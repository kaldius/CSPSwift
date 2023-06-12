/**
 Extensions to allow comparision between all `any Comparable`s.
 */
extension Comparable {
    func isGreaterThan(_ other: any Comparable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self > other
    }

    func isLessThan(_ other: any Comparable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self < other
    }
}
