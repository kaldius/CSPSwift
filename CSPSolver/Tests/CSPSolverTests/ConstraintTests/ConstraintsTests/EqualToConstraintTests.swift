import XCTest
@testable import CSPSolver

final class EqualToConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!

    var variableSet: SetOfVariables!

    var aEqualToBConstraint: EqualToConstraint!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: [1, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])

        variableSet = SetOfVariables(from: [intVariableA, intVariableB])

        aEqualToBConstraint = EqualToConstraint(intVariableA, isEqualTo: intVariableB)
    }

    func testVariableNames_returnsAllVariableNames() {
        let expectedVariableNames = [intVariableA.name, intVariableB.name]
        let actualVariableNames = aEqualToBConstraint.variableNames
        XCTAssertEqual(actualVariableNames.count, expectedVariableNames.count)
        for expectedVariableName in expectedVariableNames {
            XCTAssertTrue(actualVariableNames.contains(where: { $0 == expectedVariableName }))
        }
    }

    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        XCTAssertFalse(aEqualToBConstraint.containsAssignedVariable(state: variableSet))
    }

    func testContainsAssignedVariable_someAssigned_returnsFalse() {
        // assign A
        variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)
        XCTAssertTrue(aEqualToBConstraint.containsAssignedVariable(state: variableSet))

        // assign B
        variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)
        XCTAssertTrue(aEqualToBConstraint.containsAssignedVariable(state: variableSet))
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_bothUnassigned_returnsFalse() {
        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_oneUnassigned_returnsFalse() {
        // assign A
        variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // check B is not assigned
        XCTAssertFalse(variableSet.isAssigned(intVariableB.name))

        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aLessThanB_returnsFalse() {
        // assign A
        variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aGreaterThanB_returnsFalse() {
        // assign A
        variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        // assign B
        variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertFalse(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_aEqualToB_returnsTrue() {
        // assign A
        variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertTrue(aEqualToBConstraint.isSatisfied(state: variableSet))
    }

    // MARK: tests for isViolated
    func testIsViolated_bothUnassigned_returnsFalse() {
        XCTAssertFalse(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_oneUnassigned_returnsFalse() {
        // assign A
        variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // check B is not assigned
        XCTAssertFalse(variableSet.isAssigned(intVariableB.name))

        XCTAssertFalse(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aGreaterThanB_returnsTrue() {
        // assign A
        variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        // assign B
        variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertTrue(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aLessThanB_returnsTrue() {
        // assign A
        variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertTrue(aEqualToBConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_aEqualToB_returnsFalse() {
        // assign A
        variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        // assign B
        variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        XCTAssertFalse(aEqualToBConstraint.isViolated(state: variableSet))
    }
}
