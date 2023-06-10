import XCTest
@testable import CSPSolver

final class ComparableTests: XCTestCase {
    func testIsGreaterThan_differentTypes_returnsFalse() {
        let comparableA: any Value = 1
        let comparableB: any Value = "a"

        XCTAssertFalse(comparableA.isGreaterThan(comparableB))
        XCTAssertFalse(comparableB.isGreaterThan(comparableA))
    }

    func testIsGreaterThan_sameType_returnsCorrectResult() {
        let comparableA: any Value = 1
        let comparableB: any Value = 2

        XCTAssertFalse(comparableA.isGreaterThan(comparableB))
        XCTAssertTrue(comparableB.isGreaterThan(comparableA))
    }

    func testIsLessThan_differentTypes_returnsFalse() {
        let comparableA: any Value = 1
        let comparableB: any Value = "a"

        XCTAssertFalse(comparableA.isLessThan(comparableB))
        XCTAssertFalse(comparableB.isLessThan(comparableA))
    }

    func testIsLessThan_sameType_returnsCorrectResult() {
        let comparableA: any Value = 1
        let comparableB: any Value = 2

        XCTAssertTrue(comparableA.isLessThan(comparableB))
        XCTAssertFalse(comparableB.isLessThan(comparableA))
    }
}
