/**
 All domain values that are assignable to the variables used in this solver
 have to conform to this protocol.
 */
public protocol Value: Hashable {
    func isEqual(_ other: any Value) -> Bool
}

extension Value {
    public func isEqual(_ other: any Value) -> Bool {
        let selfAsEquatable = self as any Equatable
        let otherAsEquatable = other as any Equatable
        return selfAsEquatable.isEqual(otherAsEquatable)
    }
}

extension [any Value] {
    func isEqual(_ other: [any Value]) -> Bool {
        guard self.count == other.count else {
            return false
        }
        return (0 ..< self.count).allSatisfy({ self[$0].isEqual(other[$0]) })
    }
}

extension [[any Value]] {
    func isEqual(_ other: [[any Value]]) -> Bool {
        var equal = self.count == other.count
        for idx in 0 ..< self.count {
            equal = equal && self[idx].count == other[idx].count
            equal = equal && self[idx].isEqual(other[idx])
        }
        return equal
    }
}
