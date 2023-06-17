import XCTest
@testable import CSPSwift

final class EquatableTests: XCTestCase {
    func testIsEqual_completelyDifferentTypes_returnsFalse() {
        let equatableA = 1
        let equatableB = "a"

        XCTAssertFalse(equatableA.isEqual(equatableB))
        XCTAssertFalse(equatableB.isEqual(equatableA))
    }

    func testIsEqual_differentTypesButCastable_returnsTrue() {
        let equatableA: any Equatable = 1.0
        let equatableB: Double = 1.0

        XCTAssertTrue(equatableA.isEqual(equatableB))
        XCTAssertTrue(equatableB.isEqual(equatableA))
    }
}
