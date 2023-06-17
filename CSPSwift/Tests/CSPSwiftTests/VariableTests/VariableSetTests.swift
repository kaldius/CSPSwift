import XCTest
@testable import CSPSwift

final class VariableSetTests: XCTestCase {
    var intVariableA: IntVariable!
    var floatVariableB: FloatVariable!
    var floatVariableC: FloatVariable!

    var nonExistentVariable: IntVariable!

    var ternaryVariable: TernaryVariable!

    var variableSet: VariableSet!

    override func setUpWithError() throws {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        floatVariableB = FloatVariable(name: "floatB", domain: Set([4.123, 5.456, 6.789]))
        floatVariableC = FloatVariable(name: "floatC", domain: Set([7.987, 8.654, 9.321]))

        nonExistentVariable = IntVariable(name: "nonExistent", domain: Set([1, 5, 9]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: floatVariableB,
                                          variableC: floatVariableC)

        variableSet = try VariableSet(from: [intVariableA, floatVariableB, floatVariableC, ternaryVariable])
    }

    func testIsCompletelyAssigned_allUnassigned_returnsFalse() {
        XCTAssertFalse(variableSet.isCompletelyAssigned)
    }

    func testIsCompletelyAssigned_someAssignedSomeUnassigned_returnsFalse() {
        XCTAssertNoThrow(try variableSet.assign(intVariableA.name, to: 2))
        XCTAssertNoThrow(try variableSet.assign(floatVariableC.name, to: Float(7.987)))
        XCTAssertNoThrow(try variableSet.assign(ternaryVariable.name,
                                                to: NaryVariableValueType(value: [1, Float(4.123), Float(7.987)])))

        XCTAssertFalse(variableSet.isCompletelyAssigned)
    }

    func testIsCompletelyAssigned_allAssigned_returnsTrue() {
        XCTAssertNoThrow(try variableSet.assign(intVariableA.name, to: 2))
        XCTAssertNoThrow(try variableSet.assign(floatVariableB.name, to: Float(4.123)))
        XCTAssertNoThrow(try variableSet.assign(floatVariableC.name, to: Float(9.321)))
        XCTAssertNoThrow(try variableSet.assign(ternaryVariable.name,
                                                to: NaryVariableValueType(value: [1, Float(4.123), Float(7.987)])))

        XCTAssertTrue(variableSet.isCompletelyAssigned)
    }

    func testContainsEmptyDomain_allDomainsNonEmpty_returnsFalse() {
        XCTAssertFalse(variableSet.containsEmptyDomain)
    }

    func testContainsEmptyDomain_oneDomainsEmpty_returnsFalse() {
        XCTAssertNoThrow(try variableSet.setDomain(for: intVariableA.name, to: []))
        XCTAssertTrue(variableSet.containsEmptyDomain)
    }

    func testTotalDomainValueCount_returnsCorrectCount() {
        let expectedCount = 36
        let actualCount = variableSet.totalDomainValueCount

        XCTAssertEqual(actualCount, expectedCount)
    }

    func testInsert_variableAlreadyInserted_throwsError() {
        XCTAssertThrowsError(try variableSet.insert(intVariableA),
                             "Should throw overwritingExistingVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.overwritingExistingVariableError(name: intVariableA.name))
        })
    }

    func testInsertAndGetVariable_variableNotAlreadyInserted_correctlyInserts() throws {
        let newVariable = IntVariable(name: "intD", domain: Set([7, 8, 9]))
        try variableSet.insert(newVariable)
        let extractedVariable = try XCTUnwrap(variableSet.getVariable(newVariable.name))
        XCTAssertTrue(extractedVariable.isEqual(newVariable))
    }

    func testGetVariable_variableNotInserted_returnsNil() {
        let expectedNilValue = variableSet.getVariable(nonExistentVariable.name)
        XCTAssertNil(expectedNilValue)
    }

    func testGetVariableWithType_variableNotInserted_returnsNil() {
        let expectedNilValue = variableSet.getVariable(nonExistentVariable.name, type: IntVariable.self)
        XCTAssertNil(expectedNilValue)
    }

    func testGetVariableWithType_variableExists_returnsCorrectVariableType() throws {
        let extractedVariable = try XCTUnwrap(variableSet.getVariable(intVariableA.name, type: IntVariable.self))

        XCTAssertTrue(type(of: extractedVariable) == IntVariable.self)
    }

    func testIsAssigned_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.isAssigned(nonExistentVariable.name),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testIsAssigned_variableUnassigned_returnsFalse() {
        XCTAssertFalse(try variableSet.isAssigned(intVariableA.name))
    }

    func testIsAssigned_variableAssigned_returnsTrue() throws {
        try variableSet.assign(intVariableA.name, to: 1)
        XCTAssertTrue(try variableSet.isAssigned(intVariableA.name))
    }

    func testCanAssign_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.canAssign(nonExistentVariable.name, to: 1),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testGetAssignment_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.getAssignment(nonExistentVariable.name, type: IntVariable.self),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testGetAssignment_wrongVariableTypeProvided_throwsError() {
        XCTAssertNoThrow(try variableSet.assign(floatVariableB.name, to: Float(4.123)))
        XCTAssertThrowsError(try variableSet.getAssignment(floatVariableB.name, type: IntVariable.self),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
    }

    func testGetAssignment_variableUnassigned_returnsNil() {
        XCTAssertNil(try variableSet.getAssignment(intVariableA.name, type: IntVariable.self))
    }

    func testGetAssignment_variableAssigned_returnsCorrectAssignment() throws {
        let assignment = Float(7.987)
        XCTAssertNoThrow(try variableSet.assign(floatVariableC.name, to: assignment))
        let extractedAssignment = try variableSet.getAssignment(floatVariableC.name, type: FloatVariable.self)
        XCTAssertEqual(extractedAssignment, assignment)
    }

    func testAssign_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.assign(nonExistentVariable.name, to: 1),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testUnassign_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.unassign(nonExistentVariable.name),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testUnassign_variableCorrectlyUnassigned() {
        XCTAssertNoThrow(try variableSet.assign(intVariableA.name, to: 1))
        XCTAssertTrue(try variableSet.isAssigned(intVariableA.name))

        XCTAssertNoThrow(try variableSet.unassign(intVariableA.name))
        XCTAssertFalse(try variableSet.isAssigned(intVariableA.name))
    }

    func testSetDomain_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.setDomain(for: nonExistentVariable.name, to: [1, 5]),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testGetAndSetDomain_domainCorrectlySet() throws {
        let originalDomain = try variableSet.getDomain(intVariableA.name)
        XCTAssertTrue(originalDomain.containsSameValues(as: intVariableA.domainAsArray))

        try variableSet.setDomain(for: intVariableA.name, to: [2, 1])
        let newDomain = try variableSet.getDomain(intVariableA.name)
        XCTAssertTrue(newDomain.containsSameValues(as: [2, 1]))
    }

    func testGetDomain_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.getDomain(nonExistentVariable.name),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testGetDomainWithType_nonExistentVariable_throwsError() {
        XCTAssertThrowsError(try variableSet.getDomain(nonExistentVariable.name, type: IntVariable.self),
                             "Should throw nonExistentVariableError",
                             { error in
            XCTAssertEqual(error as? VariableError,
                           VariableError.nonExistentVariableError(name: nonExistentVariable.name))
        })
    }

    func testGetDomainWithType_wrongVariableTypeProvided_throwsError() {
        XCTAssertThrowsError(try variableSet.getDomain(floatVariableB.name, type: IntVariable.self),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
    }
}
