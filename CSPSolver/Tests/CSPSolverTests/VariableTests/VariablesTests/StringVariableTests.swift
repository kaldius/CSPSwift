import XCTest
@testable import CSPSolver

// TODO: test cases ending with "throwsError" should be implemented after errors are implemented!!!
final class StringVariableTests: XCTestCase {
    var stringVariableDomain: Set<String>!
    var stringVariable: StringVariable!

    override func setUp() {
        super.setUp()
        stringVariableDomain = ["a", "b", "c"]
        stringVariable = StringVariable(name: "string", domain: stringVariableDomain)
    }

    // MARK: Testing methods/attributes inherited from Variable
    func testDomain_getter() {
        XCTAssertEqual(stringVariable.domain, stringVariableDomain)
    }

    func testDomain_getter_variableAssigned_returnsOnlyOneValue() {
        stringVariable.assignment = "b"
        XCTAssertEqual(stringVariable.domain, ["b"])
    }

    func testDomain_setter_validNewDomain_setsDomainCorrectly() {
        let newDomain = Set(["b", "c"])
        stringVariable.domain = newDomain

        XCTAssertEqual(stringVariable.domain, newDomain)
    }

    func testDomain_setter_notSubsetOfCurrentDomain_throwsError() {

    }

    func testAssignment_getter_initialAssignmentNil() {
        XCTAssertNil(stringVariable.assignment)
    }

    func testAssignment_setter_validNewAssignment() {
        for domainValue in stringVariableDomain {
            stringVariable.unassign()
            stringVariable.assignment = domainValue
            XCTAssertEqual(stringVariable.assignment, domainValue)
        }
    }

    func testAssignment_setter_currentAssignmentNotNil_throwsError() {

    }

    func testAssignment_setter_newAssignmentNotInDomain_throwsError() {

    }

    func testCanAssign_possibleValue_returnsTrue() {
        for domainValue in stringVariableDomain {
            XCTAssertTrue(stringVariable.canAssign(to: domainValue))
        }
    }

    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(stringVariable.canAssign(to: "e"))
        XCTAssertFalse(stringVariable.canAssign(to: 4))
        XCTAssertFalse(stringVariable.canAssign(to: true))
    }

    func testAssignTo_possibleValue_getsAssigned() throws {
        for domainValue in stringVariableDomain {
            stringVariable.unassign()
            try stringVariable.assign(to: domainValue)
            let assignment = try XCTUnwrap(stringVariable.assignment)
            XCTAssertEqual(assignment, domainValue)
        }
    }

    func testAssignTo_impossibleValue_throwsError() throws {
        /*
        XCTAssertFalse(stringVariable.assign(to: "e"))
        XCTAssertNil(stringVariable.assignment)
        stringVariable.assign(to: "c")
        XCTAssertFalse(stringVariable.assign(to: "d"))
        let stringValue = try XCTUnwrap(stringVariable.assignment)
        XCTAssertEqual(stringValue, "c")
         */
    }

    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomain = ["b", "c"]
        XCTAssertTrue(stringVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [String]()
        XCTAssertTrue(stringVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_notSubsetOfCurrentDomain_returnsFalse() {
        let newDomain = ["a", "b", "c", "d"]
        XCTAssertFalse(stringVariable.canSetDomain(to: newDomain))
    }

    func testSetDomain_validNewDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = ["a", "b"]
        stringVariable.setDomain(to: newDomain)
        let expectedDomain = Set(["a", "b"])

        XCTAssertEqual(stringVariable.domain, expectedDomain)
    }

    func testSetDomain_emptyDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = []
        stringVariable.setDomain(to: newDomain)

        XCTAssertEqual(stringVariable.domain.count, 0)
    }

    func testSetDomain_wrongValueType_throwsError() {

    }

    func testUnassign_assignmentSetToNil() throws {
        try stringVariable.assign(to: "b")
        let stringValue = try XCTUnwrap(stringVariable.assignment)
        XCTAssertEqual(stringValue, "b")
        stringVariable.unassign()
        XCTAssertNil(stringVariable.assignment)
    }
}
