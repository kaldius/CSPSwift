import XCTest
@testable import CSPSolver

// TODO: test cases ending with "throwsError" should be implemented after errors are implemented!!!
final class IntVariableTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!

    override func setUp() {
        super.setUp()
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)
    }

    // MARK: Testing methods/attributes inherited from Variable
    func testDomain_getter() {
        XCTAssertEqual(intVariable.domain, intVariableDomain)
    }

    func testDomain_getter_variableAssigned_returnsOnlyOneValue() {
        intVariable.assignment = 1
        XCTAssertEqual(intVariable.domain, [1])
    }

    func testDomain_setter_validNewDomain_setsDomainCorrectly() {
        let newDomain = Set([1, 2])
        intVariable.domain = newDomain

        XCTAssertEqual(intVariable.domain, newDomain)
    }

    func testDomain_setter_notSubsetOfCurrentDomain_throwsError() {

    }

    func testAssignment_getter_initialAssignmentNil() {
        XCTAssertNil(intVariable.assignment)
    }

    func testAssignment_setter_validNewAssignment() {
        for domainValue in intVariableDomain {
            intVariable.unassign()
            intVariable.assignment = domainValue
            XCTAssertEqual(intVariable.assignment, domainValue)
        }
    }

    func testAssignment_setter_currentAssignmentNotNil_throwsError() {

    }

    func testAssignment_setter_newAssignmentNotInDomain_throwsError() {

    }

    func testCanAssign_possibleValue_returnsTrue() {
        for domainValue in intVariableDomain {
            XCTAssertTrue(intVariable.canAssign(to: domainValue))
        }
    }

    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(intVariable.canAssign(to: 4))
        XCTAssertFalse(intVariable.canAssign(to: "success"))
        XCTAssertFalse(intVariable.canAssign(to: true))
    }

    func testAssignTo_possibleValue_getsAssigned() throws {
        for domainValue in intVariableDomain {
            intVariable.assign(to: domainValue)
            let assignment = try XCTUnwrap(intVariable.assignment)
            XCTAssertEqual(assignment, domainValue)
            intVariable.unassign()
        }
    }

    func testAssignTo_impossibleValue_throwsError() throws {
        /*
        XCTAssertFalse(intVariable.assign(to: 4))
        XCTAssertNil(intVariable.assignment)
        intVariable.assign(to: 3)
        XCTAssertFalse(intVariable.assign(to: 5))
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 3)
         */
    }

    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomain = [1, 2]
        XCTAssertTrue(intVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [Int]()
        XCTAssertTrue(intVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_notSubsetOfCurrentDomain_returnsFalse() {
        let newDomain = [2, 3, 4]
        XCTAssertFalse(intVariable.canSetDomain(to: newDomain))
    }

    func testSetDomain_validNewDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = [1, 2]
        intVariable.setDomain(to: newDomain)
        let expectedDomain = Set([1, 2])

        XCTAssertEqual(intVariable.domain, expectedDomain)
    }

    func testSetDomain_emptyDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = []
        intVariable.setDomain(to: newDomain)

        XCTAssertEqual(intVariable.domain.count, 0)
    }

    func testSetDomain_wrongValueType_throwsError() {

    }

    func testUnassign_assignmentSetToNil() throws {
        intVariable.assignment = 2
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 2)
        intVariable.unassign()
        XCTAssertNil(intVariable.assignment)
    }
}
