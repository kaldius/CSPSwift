import XCTest
@testable import CSPSwift

class StackTests: XCTestCase {

    var emptyStack: Stack<Int>!
    var intStack: Stack<Int>!

    override func setUp() {
        super.setUp()
        emptyStack = Stack()
        intStack = Stack()
        intStack.push(1)
        intStack.push(2)
        intStack.push(3)
    }

    override func tearDown() {
        emptyStack = nil
        intStack = nil
        super.tearDown()
    }

    func testPushPop_emptyStack_hasCorrectOrder() {
        let pushSequence = [5, 6, 7, 1, 2, 3]
        let expectedPopOutputs = [3, 2, 1, 7, 6, 5]

        for item in pushSequence {
            emptyStack.push(item)
        }

        var popOutputs = [Int]()

        for _ in 0..<pushSequence.count {
            guard let poppedValue = emptyStack.pop() else {
                continue
            }
            popOutputs.append(poppedValue)
        }

        XCTAssertEqual(popOutputs, expectedPopOutputs, "Push-pop order is incorrect")
    }

    func testPop_emptyStack_isNil() {
        XCTAssertNil(emptyStack.pop(), "Popping empty stack should return 'nil'")
    }

    func testPop_intStack_hasCorrectOrder() {
        XCTAssertEqual(intStack.pop(), 3, "First element popped should be '3'")
        XCTAssertEqual(intStack.pop(), 2, "Second element popped should be '2'")
        XCTAssertEqual(intStack.pop(), 1, "Third element popped should be '1'")
    }

    func testPeek_intStack_hasCorrectOrder() {
        XCTAssertEqual(intStack.peek(), 3, "First element peeked should be '3'")
        _ = intStack.pop()
        XCTAssertEqual(intStack.peek(), 2, "Second element peeked should be '2'")
        _ = intStack.pop()
        XCTAssertEqual(intStack.peek(), 1, "Third element peeked should be '1'")
    }

    func testPeek_repeatedPeeks_sameResult() {
        XCTAssertEqual(intStack.peek(), 3, "Repeated peeking should return the same value")
        XCTAssertEqual(intStack.peek(), 3, "Repeated peeking should return the same value")
        XCTAssertEqual(intStack.peek(), 3, "Repeated peeking should return the same value")
    }

    func testPeek_emptyStack_isNil() {
        XCTAssertNil(emptyStack.peek(), "Peeking empty stack should return 'nil'")
    }

    func testCount_emptyStack_isZero() {
        XCTAssertEqual(emptyStack.count, 0, "Count of empty stack should be '0'")
        _ = emptyStack.pop()
        XCTAssertEqual(emptyStack.count, 0, "Count of empty stack should be '0'")
    }

    func testCount_intStack_correctCount() {
        XCTAssertEqual(intStack.count, 3, "Count of elements in stack should be 3")
    }

    func testIsEmpty_emptyStack_isTrue() {
        XCTAssertTrue(emptyStack.isEmpty, "Empty stack's isEmpty should be 'true'")
    }

    func testIsEmpty_intStack_isFalse() {
        XCTAssertFalse(intStack.isEmpty, "Populated stack's isEmpty should be 'false'")
    }

    func testRemoveAll_emptyStack_isEmpty() {
        emptyStack.removeAll()

        XCTAssertTrue(emptyStack.isEmpty, "Empty stack should remain empty after removing all elements")
    }

    func testRemoveAll_intStack_isEmpty() {
        intStack.removeAll()

        XCTAssertTrue(intStack.isEmpty, "Populated stack should be empty after removing all elements")
    }

    func testToArray_emptyStack_isEmpty() {
        let emptyArray = emptyStack.toArray()

        XCTAssertEqual(emptyArray, [], "Empty stack should return an empty array.")
    }

    func testToArray_intStack_hasCorrectOrder() {
        let intArray = intStack.toArray()

        XCTAssertEqual(intArray, [3, 2, 1], "Populated stack returned the wrong array")
    }
}
