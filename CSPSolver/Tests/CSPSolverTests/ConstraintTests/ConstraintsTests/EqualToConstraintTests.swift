import XCTest
@testable import CSPSolver

final class EqualToConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!

    var variableSet: VariableSet!

    var aEqualToBConstraint: EqualToConstraint!

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: [1, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])

        variableSet = VariableSet(from: [intVariableA, intVariableB])

        aEqualToBConstraint = EqualToConstraint(intVariableA, isEqualTo: intVariableB)
    }

    // MARK: Testing methods/attributes inherited from Constraint
    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        XCTAssertFalse(aEqualToBConstraint.containsAssignedVariable(state: variableSet))
    }

    func testContainsAssignedVariable_someAssigned_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)
        XCTAssertTrue(aEqualToBConstraint.containsAssignedVariable(state: variableSet))

        // assign B
        try variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)
        XCTAssertTrue(aEqualToBConstraint.containsAssignedVariable(state: variableSet))
    }

    // MARK: Testing methods/attributes inherited from BinaryConstraint
    func testDependsOn_validVariableName_returnsTrue() {
        XCTAssertTrue(aEqualToBConstraint.depends(on: intVariableA.name))
        XCTAssertTrue(aEqualToBConstraint.depends(on: intVariableB.name))
    }

    func testDependsOn_invalidVariableName_returnsFalse() {
        XCTAssertFalse(aEqualToBConstraint.depends(on: "nonExistentVariableName"))
    }

    func testVariableNameOtherThan_validVariableNames_returnsOtherVariableName() {
        var expected = intVariableA.name
        var actual = aEqualToBConstraint.variableName(otherThan: intVariableB.name)
        XCTAssertEqual(actual, expected)

        expected = intVariableB.name
        actual = aEqualToBConstraint.variableName(otherThan: intVariableA.name)
        XCTAssertEqual(actual, expected)
    }

    func testVariableNameOtherThan_invalidVariableName_returnsNil() {
        XCTAssertNil(aEqualToBConstraint.variableName(otherThan: "nonExistentVariableName"))
    }

    // MARK: Testing methods/attributes declared in EqualToConstraint
    func testVariableNames_returnsAllVariableNames() {
        let expectedVariableNames = [intVariableA.name, intVariableB.name]
        let actualVariableNames = aEqualToBConstraint.variableNames
        XCTAssertEqual(actualVariableNames.count, expectedVariableNames.count)
        for expectedVariableName in expectedVariableNames {
            XCTAssertTrue(actualVariableNames.contains(where: { $0 == expectedVariableName }))
        }
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_bothUnassigned_returnsFalse() {
        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_oneUnassigned_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // check B is not assigned
        XCTAssertFalse(variableSet.isAssigned(intVariableB.name))

        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aLessThanB_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aGreaterThanB_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aEqualToB_returnsTrue() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertTrue(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    // MARK: tests for isViolated
    func testIsViolated_bothUnassigned_returnsFalse() throws {
        XCTAssertFalse(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_oneUnassigned_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // check B is not assigned
        XCTAssertFalse(variableSet.isAssigned(intVariableB.name))

        XCTAssertFalse(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aGreaterThanB_returnsTrue() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertTrue(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aLessThanB_returnsTrue() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertTrue(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aEqualToB_returnsFalse() throws {
        // assign A
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        try variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertFalse(aEqualToBConstraint.isViolated(state: variableSet))
    }
}
