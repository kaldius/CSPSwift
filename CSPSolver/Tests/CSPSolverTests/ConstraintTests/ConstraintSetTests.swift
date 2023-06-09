import XCTest
@testable import CSPSolver

final class ConstraintSetTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!

    var variableSet: SetOfVariables!

    var aGreaterThanB: GreaterThanConstraint!
    var cGreaterThanA: GreaterThanConstraint!

    var constraintSet: ConstraintSet!

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: [1, 3, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])
        intVariableC = IntVariable(name: "intC", domain: [2, 3, 4, 5])

        variableSet = SetOfVariables(from: [intVariableA, intVariableB, intVariableC])

        aGreaterThanB = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)
        cGreaterThanA = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableA)

        constraintSet = ConstraintSet(allConstraints: [aGreaterThanB, cGreaterThanA])
    }

    func testAllConstraints_returnsAllConstraints() {
        let expectedConstraintArray = [aGreaterThanB, cGreaterThanA]
        let actualConstraintArray = constraintSet.allConstraints

        XCTAssertEqual(actualConstraintArray.count, expectedConstraintArray.count)
        for expectedConstraint in expectedConstraintArray {
            XCTAssertTrue(actualConstraintArray.contains(where: { $0.isEqual(expectedConstraint) }))
        }
    }

    func testAdd_constraintGetsAdded() {
        let newConstraint = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableB)
        constraintSet.add(constraint: newConstraint)

        let expectedConstraintArray = [aGreaterThanB, cGreaterThanA, newConstraint]
        let actualConstraintArray = constraintSet.allConstraints

        XCTAssertEqual(actualConstraintArray.count, expectedConstraintArray.count)
        for expectedConstraint in expectedConstraintArray {
            XCTAssertTrue(actualConstraintArray.contains(where: { $0.isEqual(expectedConstraint) }))
        }
    }

    func testAllSatisfied_allNotSatisfied_returnsFalse() {
        variableSet.assign(intVariableA.name, to: 3)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 3)

        variableSet.assign(intVariableB.name, to: 3)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 3)

        variableSet.assign(intVariableC.name, to: 2)
        let assignmentC = variableSet.getAssignment(intVariableC.name, type: IntVariable.self)
        XCTAssertEqual(assignmentC, 2)

        XCTAssertFalse(aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertFalse(cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertFalse(constraintSet.allSatisfied(state: variableSet))
    }

    func testAllSatisfied_oneNotSatisfied_returnsFalse() {
        variableSet.assign(intVariableA.name, to: 5)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 5)

        variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertTrue(aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertFalse(cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertFalse(constraintSet.allSatisfied(state: variableSet))
    }

    func testAllSatisfied_allSatisfied_returnsTrue() {
        variableSet.assign(intVariableA.name, to: 3)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 3)

        variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        variableSet.assign(intVariableC.name, to: 4)
        let assignmentC = variableSet.getAssignment(intVariableC.name, type: IntVariable.self)
        XCTAssertEqual(assignmentC, 4)

        XCTAssertTrue(aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertTrue(cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertTrue(constraintSet.allSatisfied(state: variableSet))
    }
}
