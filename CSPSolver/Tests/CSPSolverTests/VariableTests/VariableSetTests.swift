import XCTest
@testable import CSPSolver

// TODO: test cases ending with "throwsError" should be implemented after errors are implemented!!!
final class VariableSetTests: XCTestCase {
    var intVariableA: IntVariable!
    var floatVariableB: FloatVariable!
    var floatVariableC: FloatVariable!

    var ternaryVariable: TernaryVariable!

    var variableSet: VariableSet!

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        floatVariableB = FloatVariable(name: "floatB", domain: Set([4.123, 5.456, 6.789]))
        floatVariableC = FloatVariable(name: "floatC", domain: Set([7.987, 8.654, 9.321]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: floatVariableB,
                                          variableC: floatVariableC)

        variableSet = VariableSet(from: [intVariableA, floatVariableB, floatVariableC, ternaryVariable])
    }

    func testIsCompletelyAssigned_allUnassigned_returnsFalse() {
        XCTAssertFalse(variableSet.isCompletelyAssigned)
    }

    func testIsCompletelyAssigned_someAssignedSomeUnassigned_returnsFalse() {
        variableSet.assign(intVariableA.name, to: 2)
        variableSet.assign(floatVariableC.name, to: Float(7.987))
        variableSet.assign(ternaryVariable.name, to: NaryVariableValueType(value: [1, Float(4.123), Float(7.987)]))

        XCTAssertFalse(variableSet.isCompletelyAssigned)
    }

    func testIsCompletelyAssigned_allAssigned_returnsTrue() {
        variableSet.assign(intVariableA.name, to: 2)
        variableSet.assign(floatVariableB.name, to: Float(4.123))
        variableSet.assign(floatVariableC.name, to: Float(9.321))
        variableSet.assign(ternaryVariable.name, to: NaryVariableValueType(value: [1, Float(4.123), Float(7.987)]))

        XCTAssertTrue(variableSet.isCompletelyAssigned)
    }

    // TODO: test nextUnassignedVariable after pulling out as a separate protocol

    func testContainsEmptyDomain_allDomainsNonEmpty_returnsFalse() {
        XCTAssertFalse(variableSet.containsEmptyDomain)
    }

    func testContainsEmptyDomain_oneDomainsEmpty_returnsFalse() {
        variableSet.setDomain(for: intVariableA.name, to: [])
        XCTAssertTrue(variableSet.containsEmptyDomain)
    }

    func testTotalDomainValueCount_returnsCorrectCount() {
        let expectedCount = 36
        let actualCount = variableSet.totalDomainValueCount

        XCTAssertEqual(actualCount, expectedCount)
    }

    func testInsert_variableAlreadyInserted_throwsError() {

    }

    func testInsertAndGetVariable_variableNotAlreadyInserted_correctlyInserts() throws {
        let newVariable = IntVariable(name: "intD", domain: Set([7, 8, 9]))
        variableSet.insert(newVariable)
        let extractedVariable = try XCTUnwrap(variableSet.getVariable(newVariable.name))
        XCTAssertTrue(extractedVariable.isEqual(newVariable))
    }

    func testGetVariable_variableNotInserted_returnsNil() {
        let expectedNilValue = variableSet.getVariable("nonExistentVariableName")
        XCTAssertNil(expectedNilValue)
    }

    func testGetVariableWithType_variableNotInserted_returnsNil() {
        let nonExistentVariable = IntVariable(name: "nonExistent", domain: Set([1, 5, 9]))
        let expectedNilValue = variableSet.getVariable(nonExistentVariable.name, type: IntVariable.self)
        XCTAssertNil(expectedNilValue)
    }

    func testIsAssigned_nonExistentVariable_throwsError() {

    }

    func testIsAssigned_returnsCorrectValue() {
        XCTAssertFalse(variableSet.isAssigned(intVariableA.name))
        variableSet.assign(intVariableA.name, to: 1)
        XCTAssertTrue(variableSet.isAssigned(intVariableA.name))
    }

    func testGetAssignment_nonExistentVariable_throwsError() {

    }

    func testGetAssignment_variableUnassigned_returnsNil() {
        XCTAssertNil(variableSet.getAssignment(intVariableA.name, type: IntVariable.self))
    }

    func testAssignAndGetAssignment_variableAssigned_returnsCorrectAssignment() {
        let assignment = Float(7.987)
        variableSet.assign(floatVariableC.name, to: assignment)
        let extractedAssignment = variableSet.getAssignment(floatVariableC.name, type: FloatVariable.self)
        XCTAssertEqual(extractedAssignment, assignment)
    }

    func testAssign_nonExistentVariable_throwsError() {

    }

    func testAssign_cannotAssignVariable_throwsError() {

    }

    func testUnassign_nonExistentVariable_throwsError() {

    }

    func testUnassign_variableCorrectlyUnassigned() {
        variableSet.assign(intVariableA.name, to: 1)
        XCTAssertTrue(variableSet.isAssigned(intVariableA.name))

        variableSet.unassign(intVariableA.name)
        XCTAssertFalse(variableSet.isAssigned(intVariableA.name))
    }

    func testSetDomain_nonExistentVariable_throwsError() {

    }

    func testGetAndSetDomain_domainCorrectlySet() {
        let originalDomain = variableSet.getDomain(intVariableA.name)
        XCTAssertTrue(originalDomain.isEqual(intVariableA.domainAsArray))

        variableSet.setDomain(for: intVariableA.name, to: [2, 1])
        let newDomain = variableSet.getDomain(intVariableA.name)
        XCTAssertTrue(newDomain.containsSameValues(as: [2, 1]))
    }

    func testGetDomain_nonExistentVariable_throwsError() {

    }
}
