import XCTest
@testable import CSPSolver

final class Float_ValueTests: XCTestCase {
    func testInit_passingInInt_returnsFloatOfCorrectValue() throws {
        let testInt: any Value = Int(3)
        let initResult = try XCTUnwrap(Float(testInt))

        XCTAssertEqual(initResult, Float(3))
    }

    func testInit_passingInFloat_returnsFloatOfCorrectValue() throws {
        let testFloat: any Value = Float(3.123)
        let initResult = try XCTUnwrap(Float(testFloat))

        XCTAssertEqual(initResult, Float(3.123))
    }
}
