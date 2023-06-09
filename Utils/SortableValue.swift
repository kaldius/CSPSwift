public struct SortableValue<T: Value> {
    public var value: T
    public var priority: Int
    
    init(value: T, priority: Int = 0) {
        self.value = value
        self.priority = priority
    }
}

extension SortableValue: Comparable {
    // TODO: check if the comparison direction is correct
    public static func < (lhs: SortableValue<T>, rhs: SortableValue<T>) -> Bool {
        lhs.priority < rhs.priority
    }

    public static func == (lhs: SortableValue<T>, rhs: SortableValue<T>) -> Bool {
        lhs.value == rhs.value
        && lhs.priority == rhs.priority
    }
}
