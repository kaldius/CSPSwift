/**
 A generic `Stack` whose elements are last-in, first-out.
 */
struct Stack<T> {

    private var stackArray = [T]()

    /// Adds an element to the top of the stack.
    /// - Parameter item: The element to be added to the stack
    mutating func push(_ item: T) {
        stackArray.append(item)
    }

    /// Removes the element at the top of the stack and return it.
    /// - Returns: element at the top of the stack
    @discardableResult
    mutating func pop() -> T? {
        stackArray.popLast()
    }

    /// Returns, but does not remove, the element at the top of the stack.
    /// - Returns: element at the top of the stack
    func peek() -> T? {
        stackArray.last
    }

    /// The number of elements currently in the stack.
    var count: Int {
        stackArray.count
    }

    /// Whether the stack is empty.
    var isEmpty: Bool {
        stackArray.isEmpty
    }

    /// Removes all elements in the stack.
    mutating func removeAll() {
        stackArray.removeAll()
    }

    /// Returns an array of the elements in their respective pop order, i.e.
    /// first element in the array is the first element to be popped.
    /// - Returns: array of elements in their respective pop order
    func toArray() -> [T] {
        stackArray.reversed()
    }
}
