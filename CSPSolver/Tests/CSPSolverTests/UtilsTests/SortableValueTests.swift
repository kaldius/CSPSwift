import XCTest
@testable import CSPSolver

final class SortableValueTests: XCTestCase {
    func testSortInt() {
        let sortableA = SortableValue(value: "A", priority: 1)
        let sortableB = SortableValue(value: "B", priority: 2)
        let sortableC = SortableValue(value: "C", priority: 3)
        let sortableD = SortableValue(value: "D", priority: 4)

        var sortables = [sortableB, sortableD, sortableA, sortableC]
        sortables.sort()

        let exptectedSortedArr = [sortableA, sortableB, sortableC, sortableD]

        XCTAssertEqual(sortables, exptectedSortedArr)
    }
}
