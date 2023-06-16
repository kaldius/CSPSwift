/**
 * Queue implemented with a singly-linked list.
 *
 * Offers O(1) adding to back and removing from front.
 */
struct Queue<T> {
    class Node<T> {
        let value: T
        var next: Node?

        init(value: T, next: Node? = nil) {
            self.value = value
            self.next = next
        }

        convenience init(value: T) {
            self.init(value: value, next: nil)
        }
    }

    private var front: Node<T>?
    private var back: Node<T>?
    private(set) var count: Int
    public var isEmpty: Bool { front == nil }

    init(from array: [T] = [T]()) {
        self.count = 0
        array.forEach({ self.enqueue($0) })
    }

    /**
     * Adds a new value to the queue
     */
    public mutating func enqueue(_ value: T) {
        let fresh = Node(value: value)
        if back != nil {
            back?.next = fresh
        }
        back = fresh
        if front == nil {
            front = back
        }
        count += 1
    }

    /**
     * Adds every element an an input array to the tail of the queue in order.
     */
    mutating func enqueueAll(in array: [T]) {
        array.forEach({ self.enqueue($0) })
    }

    /**
     * Retrieves the value at the front of the queue
     */
    @discardableResult
    public mutating func dequeue() -> T? {
        defer {
            if let next = front?.next {
                front = next
            } else {
                (front, back) = (nil, nil)
            }
            count = max(0, count - 1)
        }
        return front?.value
    }

    /**
     * Returns, but does not remove, the element at the head of the queue.
     */
    func peek() -> T? {
        front?.value
    }

    /**
     * Removes all elements in the queue.
     */
    mutating func removeAll() {
        (front, back) = (nil, nil)
    }

    /**
     * Returns an array of the elements in their respective dequeue order, i.e.
     * first element in the array is the first element to be dequeued.
     * - Returns: array of elements in their respective dequeue order
     */
    func toArray() -> [T] {
        var outputArr = [T]()
        var ptr = front
        while true {
            guard let element = ptr?.value else {
                break
            }
            outputArr.append(element)
            ptr = ptr?.next
        }
        return outputArr
    }
}

// Display implementation for a single node
extension Queue.Node: CustomStringConvertible {
    public var description: String {
        if let next = next {
            return String(describing: next) + " <- " + "\(value)"
        }
        return "\(value)"
    }
}

// Display implementation for the queue
extension Queue: CustomStringConvertible {
    public var description: String {
        if let front = front {
            return "[" + front.description + "]"
        }
        return "[]"
    }
}

extension Queue<Arc> {
    /// Initializes a `Queue<Arc>` with a forward and backward `Arc` for every `Constraint`.
    init(given constraintSet: ConstraintSet) {
        let arcs = constraintSet.allConstraints.flatMap({ [Arc(from: $0), Arc(from: $0, reverse: true)] })
            .compactMap({ $0 })
        self.init(from: arcs)
    }
}
