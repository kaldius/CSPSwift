import XCTest
@testable import CSPSolver

final class ConstraintSetTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!
    var ternaryVariable: TernaryVariable!

    var variableSet: SetOfVariables!

    var aGreaterThanB: GreaterThanConstraint!
    var cGreaterThanA: GreaterThanConstraint!
    var linearCombinationConstraint: LinearCombinationConstraint!

    var constraintSet: ConstraintSet!

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: [1, 3, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])
        intVariableC = IntVariable(name: "intC", domain: [2, 3, 4, 5])
        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: intVariableB,
                                          variableC: intVariableC)

        variableSet = SetOfVariables(from: [intVariableA, intVariableB, intVariableC, ternaryVariable])

        aGreaterThanB = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)
        cGreaterThanA = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableA)
        linearCombinationConstraint = LinearCombinationConstraint(ternaryVariable,
                                                                  scaleA: 1,
                                                                  scaleB: 1,
                                                                  scaleC: 1,
                                                                  add: -8)

        constraintSet = ConstraintSet(allConstraints: [aGreaterThanB, cGreaterThanA, linearCombinationConstraint])
    }

    func testAllConstraints_returnsAllConstraints() {
        let expectedConstraintArray: [any Constraint] = [aGreaterThanB,
                                                         cGreaterThanA,
                                                         linearCombinationConstraint]
        let actualConstraintArray = constraintSet.allConstraints

        XCTAssertEqual(actualConstraintArray.count, expectedConstraintArray.count)
        for expectedConstraint in expectedConstraintArray {
            XCTAssertTrue(actualConstraintArray.contains(where: { $0.isEqual(expectedConstraint) }))
        }
    }

    func testUnaryConstraints_returnsAllUnaryConstraints() {
        let expectedUnaryConstraintArray = [linearCombinationConstraint]
        let actualUnaryConstraintArray = constraintSet.unaryConstraints

        XCTAssertEqual(actualUnaryConstraintArray.count, expectedUnaryConstraintArray.count)
        for expectedConstraint in expectedUnaryConstraintArray {
            XCTAssertTrue(actualUnaryConstraintArray.contains(where: { $0.isEqual(expectedConstraint) }))
        }
    }

    func testAdd_constraintGetsAdded() {
        let newConstraint = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableB)
        constraintSet.add(constraint: newConstraint)

        let expectedConstraintArray: [any Constraint] = [aGreaterThanB,
                                                         cGreaterThanA,
                                                         linearCombinationConstraint,
                                                         newConstraint]
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

        variableSet.assign(intVariableB.name, to: 1)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 1)

        variableSet.assign(intVariableC.name, to: 4)
        let assignmentC = variableSet.getAssignment(intVariableC.name, type: IntVariable.self)
        XCTAssertEqual(assignmentC, 4)

        variableSet.assign(ternaryVariable.name, to: NaryVariableValueType(value: [3, 1, 4]))
        let ternaryAssignment = variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryAssignment, NaryVariableValueType(value: [3, 1, 4]))

        XCTAssertTrue(aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertTrue(cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertTrue(constraintSet.allSatisfied(state: variableSet))
    }

    func testApplyUnaryConstraints() {
        // only testing unary constraint, so only ternaryVariable domain should be restricted
        let expectedIntVariableADomain = [1, 3, 4, 5]
        let expectedIntVariableBDomain = [1, 2, 3]
        let expectedIntVariableCDomain = [2, 3, 4, 5]
        let expectedTernaryVariableDomain = [NaryVariableValueType(value: [3, 1, 4])]

        let newVariableSet = constraintSet.applyUnaryConstraints(to: variableSet)

        let actualIntVariableADomain = newVariableSet.getDomain(intVariableA.name, type: IntVariable.self)
        let actualIntVariableBDomain = newVariableSet.getDomain(intVariableB.name, type: IntVariable.self)
        let actualIntVariableCDomain = newVariableSet.getDomain(intVariableC.name, type: IntVariable.self)
        let actualTernaryVariableDomain = newVariableSet.getDomain(ternaryVariable.name, type: TernaryVariable.self)

        XCTAssertEqual(actualIntVariableADomain, actualIntVariableADomain)
        XCTAssertEqual(actualIntVariableBDomain, actualIntVariableBDomain)
        XCTAssertEqual(actualIntVariableCDomain, actualIntVariableCDomain)
        XCTAssertEqual(actualTernaryVariableDomain, actualTernaryVariableDomain)
    }

    func testRemoveUnaryConstraints() {
        let originalUnaryConstraints = constraintSet.unaryConstraints
        XCTAssertFalse(originalUnaryConstraints.isEmpty)

        constraintSet.removeUnaryConstraints()

        let newUnaryConstraints = constraintSet.unaryConstraints
        XCTAssertTrue(newUnaryConstraints.isEmpty)
    }
}
