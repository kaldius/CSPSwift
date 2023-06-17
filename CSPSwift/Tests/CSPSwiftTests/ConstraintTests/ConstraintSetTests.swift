import XCTest
@testable import CSPSwift

final class ConstraintSetTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!
    var ternaryVariable: TernaryVariable!

    var variableSet: VariableSet!

    var aGreaterThanB: GreaterThanConstraint!
    var cGreaterThanA: GreaterThanConstraint!
    var linearCombinationConstraint: LinearCombinationConstraint!

    var constraintSet: ConstraintSet!

    override func setUpWithError() throws {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: [1, 3, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])
        intVariableC = IntVariable(name: "intC", domain: [2, 3, 4, 5])
        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: intVariableB,
                                          variableC: intVariableC)

        variableSet = try VariableSet(from: [intVariableA, intVariableB, intVariableC, ternaryVariable])

        aGreaterThanB = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)
        cGreaterThanA = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableA)
        // correct answer: [4, 3, 5]
        linearCombinationConstraint = LinearCombinationConstraint(ternaryVariable,
                                                                  scaleA: 3,
                                                                  scaleB: 1,
                                                                  scaleC: 6,
                                                                  add: -45)

        constraintSet = ConstraintSet([aGreaterThanB, cGreaterThanA, linearCombinationConstraint])
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

    func testBinaryConstraints_returnsAllBinaryConstraints() {
        let expectedBinaryConstraintArray = [aGreaterThanB, cGreaterThanA]
        let actualBinaryConstraintArray = constraintSet.binaryConstraints

        XCTAssertEqual(actualBinaryConstraintArray.count, expectedBinaryConstraintArray.count)
        for expectedConstraint in expectedBinaryConstraintArray {
            XCTAssertTrue(actualBinaryConstraintArray.contains(where: { $0.isEqual(expectedConstraint) }))
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

    func testAllSatisfied_allNotSatisfied_returnsFalse() throws {
        try variableSet.assign(intVariableA.name, to: 3)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 3)

        try variableSet.assign(intVariableB.name, to: 3)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 3)

        try variableSet.assign(intVariableC.name, to: 2)
        let assignmentC = try variableSet.getAssignment(intVariableC.name, type: IntVariable.self)
        XCTAssertEqual(assignmentC, 2)

        XCTAssertFalse(try aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertFalse(try cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertFalse(try constraintSet.allSatisfied(state: variableSet))
    }

    func testAllSatisfied_oneNotSatisfied_returnsFalse() throws {
        try variableSet.assign(intVariableA.name, to: 5)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 5)

        try variableSet.assign(intVariableB.name, to: 2)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 2)

        XCTAssertTrue(try aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertFalse(try cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertFalse(try constraintSet.allSatisfied(state: variableSet))
    }

    func testAllSatisfied_allSatisfied_returnsTrue() throws {
        try variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        try variableSet.assign(intVariableB.name, to: 3)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 3)

        try variableSet.assign(intVariableC.name, to: 5)
        let assignmentC = try variableSet.getAssignment(intVariableC.name, type: IntVariable.self)
        XCTAssertEqual(assignmentC, 5)

        try variableSet.assign(ternaryVariable.name, to: NaryVariableValueType(value: [4, 3, 5]))
        let ternaryAssignment = try variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryAssignment, NaryVariableValueType(value: [4, 3, 5]))

        XCTAssertTrue(try aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertTrue(try cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertTrue(try constraintSet.allSatisfied(state: variableSet))
    }

    func testAnyViolated_allUnassigned_returnsFalse() throws {
        XCTAssertFalse(try constraintSet.anyViolated(state: variableSet))
    }

    func testAnyViolated_oneViolated_returnsTrue() throws {
        try variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        try variableSet.assign(intVariableB.name, to: 3)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 3)

        try variableSet.assign(intVariableC.name, to: 2)
        let assignmentC = try variableSet.getAssignment(intVariableC.name, type: IntVariable.self)
        XCTAssertEqual(assignmentC, 2)

        XCTAssertFalse(try aGreaterThanB.isViolated(state: variableSet))
        XCTAssertTrue(try cGreaterThanA.isViolated(state: variableSet))

        XCTAssertTrue(try constraintSet.anyViolated(state: variableSet))
    }

    func testAnyViolated_allSatisfied_returnsFalse() throws {
        try variableSet.assign(intVariableA.name, to: 4)
        let assignmentA = try variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 4)

        try variableSet.assign(intVariableB.name, to: 3)
        let assignmentB = try variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 3)

        try variableSet.assign(intVariableC.name, to: 5)
        let assignmentC = try variableSet.getAssignment(intVariableC.name, type: IntVariable.self)
        XCTAssertEqual(assignmentC, 5)

        try variableSet.assign(ternaryVariable.name, to: NaryVariableValueType(value: [4, 3, 5]))
        let ternaryAssignment = try variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryAssignment, NaryVariableValueType(value: [4, 3, 5]))

        XCTAssertTrue(try aGreaterThanB.isSatisfied(state: variableSet))
        XCTAssertTrue(try cGreaterThanA.isSatisfied(state: variableSet))

        XCTAssertFalse(try constraintSet.anyViolated(state: variableSet))
    }

    func testApplyUnaryConstraints() throws {
        // only testing unary constraint, so only ternaryVariable domain should be restricted
        let expectedIntVariableADomain: [any Value] = [1, 3, 4, 5]
        let expectedIntVariableBDomain: [any Value] = [1, 2, 3]
        let expectedIntVariableCDomain: [any Value] = [2, 3, 4, 5]
        let expectedTernaryVariableDomain: [any Value] = [NaryVariableValueType(value: [4, 3, 5])]

        let newVariableSet = try constraintSet.applyUnaryConstraints(to: variableSet)

        let actualIntVariableADomain = try newVariableSet.getDomain(intVariableA.name)
        let actualIntVariableBDomain = try newVariableSet.getDomain(intVariableB.name)
        let actualIntVariableCDomain = try newVariableSet.getDomain(intVariableC.name)
        let actualTernaryVariableDomain = try newVariableSet.getDomain(ternaryVariable.name)

        XCTAssertTrue(actualIntVariableADomain.containsSameValues(as: expectedIntVariableADomain))
        XCTAssertTrue(actualIntVariableBDomain.containsSameValues(as: expectedIntVariableBDomain))
        XCTAssertTrue(actualIntVariableCDomain.containsSameValues(as: expectedIntVariableCDomain))
        XCTAssertTrue(actualTernaryVariableDomain.containsSameValues(as: expectedTernaryVariableDomain))
    }

    func testRemoveUnaryConstraints() {
        let originalUnaryConstraints = constraintSet.unaryConstraints
        XCTAssertFalse(originalUnaryConstraints.isEmpty)

        constraintSet.removeUnaryConstraints()

        let newUnaryConstraints = constraintSet.unaryConstraints
        XCTAssertTrue(newUnaryConstraints.isEmpty)
    }
}
