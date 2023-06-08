/**
 All domain values that are assignable to the variables used in this solver
 have to conform to this protocol.
 */
public protocol Value: Hashable, Comparable, Copyable {
    func isEqual(_ other: any Value) -> Bool
}

extension Value {
    public func isEqual(_ other: any Value) -> Bool {
        let selfAsEquatable = self as any Equatable
        let otherAsEquatable = other as any Equatable
        return selfAsEquatable.isEqual(otherAsEquatable)
    }

    public func isGreaterThan(_ other: any Value) -> Bool {
        let selfAsComparable = self as any Comparable
        let otherAsComparable = other as any Comparable
        return selfAsComparable.isGreaterThan(otherAsComparable)
    }

    public func isLessThan(_ other: any Value) -> Bool {
        let selfAsComparable = self as any Comparable
        let otherAsComparable = other as any Comparable
        return selfAsComparable.isLessThan(otherAsComparable)
    }
}

extension [any Value] {
    func isEqual(_ other: [any Value]) -> Bool {
        guard self.count == other.count else {
            return false
        }
        return (0 ..< self.count).allSatisfy({ self[$0].isEqual(other[$0]) })
    }

    func copy() -> [any Value] {
        self.map({ $0.copy() })
    }

    func containsSameValues(as array: [any Value]) -> Bool {
        var correct = self.count == array.count
        for value in self {
            correct = correct && array.contains(where: { $0.isEqual(value) })
        }
        return correct
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

    func containsSameValues(as array: [[any Value]]) -> Bool {
        var correct = self.count == array.count
        for valueArray in self {
            correct = correct && array.contains(where: { $0.containsSameValues(as: valueArray) })
        }
        return correct
    }
}
