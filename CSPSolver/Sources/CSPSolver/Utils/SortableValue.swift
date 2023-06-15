/**
 A wrapper for `Value` that also takes in an integer `priority`.
 */
public struct SortableValue<T: Value> {
    public var value: T
    public var priority: Int

    init(value: T, priority: Int = 0) {
        self.value = value
        self.priority = priority
    }
}

/**
 Higher priority == larger
 */
extension SortableValue: Comparable {
    public static func < (lhs: SortableValue<T>, rhs: SortableValue<T>) -> Bool {
        lhs.priority < rhs.priority
    }

    public static func == (lhs: SortableValue<T>, rhs: SortableValue<T>) -> Bool {
        lhs.value == rhs.value
        && lhs.priority == rhs.priority
    }
}
