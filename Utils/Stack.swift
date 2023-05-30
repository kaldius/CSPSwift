/**
 A generic `Stack` class whose elements are last-in, first-out.
 */
public struct Stack<T> {

    private var stackArray = [T]()

    /// Adds an element to the top of the stack.
    /// - Parameter item: The element to be added to the stack
    public mutating func push(_ item: T) {
        stackArray.append(item)
    }

    /// Removes the element at the top of the stack and return it.
    /// - Returns: element at the top of the stack
    @discardableResult
    public mutating func pop() -> T? {
        stackArray.popLast()
    }

    /// Returns, but does not remove, the element at the top of the stack.
    /// - Returns: element at the top of the stack
    public func peek() -> T? {
        stackArray.last
    }

    /// The number of elements currently in the stack.
    public var count: Int {
        stackArray.count
    }

    /// Whether the stack is empty.
    public var isEmpty: Bool {
        stackArray.isEmpty
    }

    /// Removes all elements in the stack.
    public mutating func removeAll() {
        stackArray.removeAll()
    }

    /// Returns an array of the elements in their respective pop order, i.e.
    /// first element in the array is the first element to be popped.
    /// - Returns: array of elements in their respective pop order
    public func toArray() -> [T] {
        stackArray.reversed()
    }
}

extension Stack: Copyable {
    public func copy() -> Stack<T> {
        self
    }
}
