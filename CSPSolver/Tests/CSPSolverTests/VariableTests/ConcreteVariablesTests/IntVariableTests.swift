import XCTest
@testable import CSPSolver

final class IntVariableTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!

    override func setUp() {
        super.setUp()
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)
    }

    // MARK: Testing methods/attributes declared in IntVariable
    func testDomain_returnsCorrectDomain() {
        XCTAssertEqual(intVariable.domain, intVariableDomain)
    }

    func testDomain_variableAssigned_returnsOnlyOneValue() {
        XCTAssertNoThrow(try intVariable.assign(to: 1))
        XCTAssertEqual(intVariable.domain, [1])
    }

    func testAssignment_initialAssignment_returnsNil() {
        XCTAssertNil(intVariable.assignment)
    }

    func testAssignTo_possibleValue_correctlyAssigned() throws {
        for domainValue in intVariableDomain {
            XCTAssertNoThrow(try intVariable.assign(to: domainValue))
            let assignment = try XCTUnwrap(intVariable.assignment)
            XCTAssertEqual(assignment, domainValue)
            intVariable.unassign()
        }
    }

    func testAssignTo_variableCurrentlyAssigned_throwsError() {
        XCTAssertNoThrow(try intVariable.assign(to: 1))
        XCTAssertThrowsError(try intVariable.assign(to: 2),
                             "Should throw overwritingExistingAssignmentError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.overwritingExistingAssignmentError) })
        XCTAssertEqual(intVariable.assignment, 1)
    }

    func testAssignTo_valueNotInDomain_throwsError() throws {
        // assign to 4 fails
        XCTAssertThrowsError(try intVariable.assign(to: 4),
                             "Should throw assignmentNotInDomainError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.assignmentNotInDomainError) })
        XCTAssertNil(intVariable.assignment)
        // assign to 3 passes
        XCTAssertNoThrow(try intVariable.assign(to: 3))
    }

    func testSetDomainTo_validNewDomain_setsDomainCorrectly() throws {
        let newDomain = Set([1, 2])
        try intVariable.setDomain(to: newDomain)

        XCTAssertEqual(intVariable.domain, newDomain)
    }

    func testSetDomainTo_emptyDomain_setsDomainCorrectly() throws {
        let newDomain: Set<Int> = Set()
        try intVariable.setDomain(to: newDomain)

        XCTAssertEqual(intVariable.domain.count, 0)
    }

    func testSetDomainTo_notSubsetOfCurrentDomain_throwsError() {
        let newDomain = Set([2, 3, 4])
        XCTAssertThrowsError(try intVariable.setDomain(to: newDomain),
                             "Should throw incompatibleDomainError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.incompatibleDomainError) })
    }

    func testUnassign_assignmentSetToNil() throws {
        XCTAssertNoThrow(try intVariable.assign(to: 2))
        XCTAssertEqual(intVariable.assignment, 2)
        intVariable.unassign()
        XCTAssertNil(intVariable.assignment)
    }

    // MARK: Testing methods/attributes inherited from Variable
    func testAssignToAnyValue_wrongValueType_throwsError() throws {
        XCTAssertThrowsError(try intVariable.assign(to: "success"),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
        XCTAssertThrowsError(try intVariable.assign(to: true),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
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

    func testSetDomainToAnyValue_validNewDomain_setsDomainCorrectly() throws {
        let newDomain: [any Value] = [1, 2]
        try intVariable.setDomain(to: newDomain)
        let expectedDomain = Set([1, 2])

        XCTAssertEqual(intVariable.domain, expectedDomain)
    }

    func testSetDomainToAnyValue_emptyDomain_setsDomainCorrectly() throws {
        let newDomain: [any Value] = []
        try intVariable.setDomain(to: newDomain)

        XCTAssertEqual(intVariable.domain.count, 0)
    }

    func testSetDomainToAnyValue_wrongValueType_throwsError() {
        let newDomain = ["a", "b", "c"]
        XCTAssertThrowsError(try intVariable.setDomain(to: newDomain),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })

        XCTAssertEqual(intVariable.domain, intVariableDomain)
    }
}
