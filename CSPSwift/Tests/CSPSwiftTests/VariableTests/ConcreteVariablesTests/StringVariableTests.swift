import XCTest
@testable import CSPSwift

final class StringVariableTests: XCTestCase {
    var stringVariableDomain: Set<String>!
    var stringVariable: StringVariable!

    override func setUp() {
        super.setUp()
        stringVariableDomain = ["a", "b", "c"]
        stringVariable = StringVariable(name: "string", domain: stringVariableDomain)
    }

    // MARK: Testing methods/attributes declared in StringVariable
    func testDomain_returnsCorrectDomain() {
        XCTAssertEqual(stringVariable.domain, stringVariableDomain)
    }

    func testDomain_variableAssigned_returnsOnlyOneValue() {
        XCTAssertNoThrow(try stringVariable.assign(to: "a"))
        XCTAssertEqual(stringVariable.domain, ["a"])
    }

    func testAssignment_initialAssignment_returnsNil() {
        XCTAssertNil(stringVariable.assignment)
    }

    func testAssignTo_possibleValue_correctlyAssigned() throws {
        for domainValue in stringVariableDomain {
            XCTAssertNoThrow(try stringVariable.assign(to: domainValue))
            let assignment = try XCTUnwrap(stringVariable.assignment)
            XCTAssertEqual(assignment, domainValue)
            stringVariable.unassign()
        }
    }

    func testAssignTo_variableCurrentlyAssigned_throwsError() {
        XCTAssertNoThrow(try stringVariable.assign(to: "a"))
        XCTAssertThrowsError(try stringVariable.assign(to: "b"),
                             "Should throw overwritingExistingAssignmentError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.overwritingExistingAssignmentError) })
        XCTAssertEqual(stringVariable.assignment, "a")
    }

    func testAssignTo_valueNotInDomain_throwsError() {
        // assign to d fails
        XCTAssertThrowsError(try stringVariable.assign(to: "d"),
                             "Should throw assignmentNotInDomainError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.assignmentNotInDomainError) })
        XCTAssertNil(stringVariable.assignment)
        // assign to c passes
        XCTAssertNoThrow(try stringVariable.assign(to: "c"))
    }

    func testSetDomainTo_validNewDomain_setsDomainCorrectly() {
        let newDomain = Set(["a", "b"])
        XCTAssertNoThrow(try stringVariable.setDomain(to: newDomain))

        XCTAssertEqual(stringVariable.domain, newDomain)
    }

    func testSetDomainTo_emptyDomain_setsDomainCorrectly() {
        let newDomain: Set<String> = Set()
        XCTAssertNoThrow(try stringVariable.setDomain(to: newDomain))

        XCTAssertEqual(stringVariable.domain.count, 0)
    }

    func testSetDomainTo_notSubsetOfCurrentDomain_throwsError() {
        let newDomain = Set(["b", "c", "d"])
        XCTAssertThrowsError(try stringVariable.setDomain(to: newDomain),
                             "Should throw incompatibleDomainError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.incompatibleDomainError) })
    }

    func testUnassign_assignmentSetToNil() {
        XCTAssertNoThrow(try stringVariable.assign(to: "b"))
        XCTAssertEqual(stringVariable.assignment, "b")
        stringVariable.unassign()
        XCTAssertNil(stringVariable.assignment)
    }

    // MARK: Testing methods/attributes inherited from Variable
    func testAssignToAnyValue_wrongValueType_throwsError() {
        XCTAssertThrowsError(try stringVariable.assign(to: 7),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
        XCTAssertThrowsError(try stringVariable.assign(to: true),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
    }

    func testCanAssign_possibleValue_returnsTrue() {
        for domainValue in stringVariableDomain {
            XCTAssertTrue(stringVariable.canAssign(to: domainValue))
        }
    }

    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(stringVariable.canAssign(to: "d"))
        XCTAssertFalse(stringVariable.canAssign(to: 3))
        XCTAssertFalse(stringVariable.canAssign(to: true))
    }

    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomain = ["a", "b"]
        XCTAssertTrue(stringVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [String]()
        XCTAssertTrue(stringVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_notSubsetOfCurrentDomain_returnsFalse() {
        let newDomain = ["b", "c", "d"]
        XCTAssertFalse(stringVariable.canSetDomain(to: newDomain))
    }

    func testSetDomainToAnyValue_validNewDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = ["a", "b"]
        XCTAssertNoThrow(try stringVariable.setDomain(to: newDomain))
        let expectedDomain = Set(["a", "b"])

        XCTAssertEqual(stringVariable.domain, expectedDomain)
    }

    func testSetDomainToAnyValue_emptyDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = []
        XCTAssertNoThrow(try stringVariable.setDomain(to: newDomain))

        XCTAssertEqual(stringVariable.domain.count, 0)
    }

    func testSetDomainToAnyValue_wrongValueType_throwsError() {
        let newDomain = [1, 2, 3]
        XCTAssertThrowsError(try stringVariable.setDomain(to: newDomain),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })

        XCTAssertEqual(stringVariable.domain, stringVariableDomain)
    }
}
