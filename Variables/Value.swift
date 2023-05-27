/**
 All domain values that are assignable to the variables used in this solver
 have to conform to this protocol.
 */

public protocol Value: Hashable {
}

extension Value {
    func isEqual(_ other: any Value) -> Bool {
        guard let other = other as? Self else {
            return other.isExactlyEqual(self)
        }
        return self == other
    }

    private func isExactlyEqual(_ other: any Value) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}

extension [Value] {
    func isEqual(_ other: [any Value]) -> Bool {
        var equal = self.count == other.count
        for idx in 0 ..< self.count {
            equal = equal && self[idx].isEqual(other[idx])
        }
        return equal
    }
}

extension [[Value]] {
    func isEqual(_ other: [[any Value]]) -> Bool {
        var equal = self.count == other.count
        for idx in 0 ..< self.count {
            equal = equal && self[idx].count == other[idx].count
            equal = equal && self[idx].isEqual(other[idx])
        }
        return equal
    }
}
