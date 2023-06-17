import XCTest
@testable import CSPSwift

final class Bool_ValueTests: XCTestCase {
    func testLessThan_trueLessThanTrue_returnsFalse() {
        XCTAssertFalse(true < true)
    }

    func testLessThan_trueLessThanFalse_returnsFalse() {
        XCTAssertFalse(true < false)
    }

    func testLessThan_falseLessThanTrue_returnsTrue() {
        XCTAssertTrue(false < true)
    }

    func testLessThan_falseLessThanFalse_returnsFalse() {
        XCTAssertFalse(false < false)
    }
}
