import XCTest
@testable import CSPSolver

final class ConstraintSatisfactionProblemTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!
    var ternaryVariable: TernaryVariable!

    var variableSet: VariableSet!

    var bGreaterThanA: GreaterThanConstraint!
    var cGreaterThanB: GreaterThanConstraint!
    var linearCombinationConstraint: LinearCombinationConstraint!

    var constraintSet: ConstraintSet!

    var csp: ConstraintSatisfactionProblem!

    override func setUpWithError() throws {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3, 4, 5]))
        intVariableB = IntVariable(name: "intB", domain: Set([3, 4, 5, 6, 7]))
        intVariableC = IntVariable(name: "intC", domain: Set([5, 6, 7, 8, 9]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: intVariableB,
                                          variableC: intVariableC)

        let allVariables: [any Variable] = [intVariableA, intVariableB, intVariableC, ternaryVariable]

        variableSet = try VariableSet(from: allVariables)

        bGreaterThanA = GreaterThanConstraint(intVariableB, isGreaterThan: intVariableA)
        cGreaterThanB = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableB)
        linearCombinationConstraint = LinearCombinationConstraint(ternaryVariable,
                                                                  scaleA: 7,
                                                                  scaleB: 8,
                                                                  scaleC: 9,
                                                                  add: -111)
        
        let allConstraints: [any Constraint] = [bGreaterThanA, cGreaterThanB, linearCombinationConstraint]

        constraintSet = ConstraintSet(allConstraints)

        csp = try ConstraintSatisfactionProblem(variables: allVariables,
                                                constraints: allConstraints)
    }

    func testCanAssign_nonExistentVariable_throwsError() {

    }

    func testCanAssign_violatesConstraint_returnsFalse() throws {
        try csp.variableSet.assign(intVariableA.name, to: 5)

        // violates bGreaterThanA
        XCTAssertFalse(try csp.canAssign(intVariableB.name, to: 1))
    }

    func testCanAssign_doesNotViolateConstraint_returnsTrue() throws {
        try csp.variableSet.assign(intVariableA.name, to: 5)
        XCTAssertTrue(try csp.canAssign(intVariableB.name, to: 6))

        try csp.variableSet.assign(intVariableB.name, to: 6)
        XCTAssertTrue(try csp.canAssign(intVariableC.name, to: 7))
    }

    func testUpdateAndRevertToPreviousState_correctlyUpdatesAndReverts() throws {
        var expectedVariableSet = variableSet!
        try expectedVariableSet.setDomain(for: intVariableA.name, to: [1])
        try expectedVariableSet.assign(intVariableC.name, to: 8)

        csp.update(using: expectedVariableSet)

        XCTAssertEqual(csp.variableSet, expectedVariableSet)

        csp.revertToPreviousState()

        let revertedVariableSet = try constraintSet.applyUnaryConstraints(to: variableSet)

        XCTAssertEqual(csp.variableSet, revertedVariableSet)
    }

    func testRevertToPreviousState_alreadyAtInitialState_noChange() throws {
        let initialState = try constraintSet.applyUnaryConstraints(to: variableSet)

        for _ in 0 ..< 10 {
            csp.revertToPreviousState()
            XCTAssertEqual(csp.variableSet, initialState)
        }
    }
}
