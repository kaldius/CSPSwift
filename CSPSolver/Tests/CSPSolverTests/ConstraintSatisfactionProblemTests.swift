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

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3, 4, 5]))
        intVariableB = IntVariable(name: "intB", domain: Set([3, 4, 5, 6, 7]))
        intVariableC = IntVariable(name: "intC", domain: Set([5, 6, 7, 8, 9]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: intVariableB,
                                          variableC: intVariableC)

        let allVariables: [any Variable] = [intVariableA, intVariableB, intVariableC, ternaryVariable]

        variableSet = VariableSet(from: allVariables)

        bGreaterThanA = GreaterThanConstraint(intVariableB, isGreaterThan: intVariableA)
        cGreaterThanB = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableB)
        linearCombinationConstraint = LinearCombinationConstraint(ternaryVariable,
                                                                  scaleA: 7,
                                                                  scaleB: 8,
                                                                  scaleC: 9,
                                                                  add: -111)
        
        let allConstraints: [any Constraint] = [bGreaterThanA, cGreaterThanB, linearCombinationConstraint]

        constraintSet = ConstraintSet(allConstraints: allConstraints)

        csp = ConstraintSatisfactionProblem(variables: allVariables,
                                            constraints: allConstraints)
    }

    // TODO: test nextUnassignedVariable and orderDomainValues after pulling out as protocol

    func testUpdateAndRevertToPreviousState_correctlyUpdatesAndReverts() {
        var expectedVariableSet = variableSet!
        expectedVariableSet.setDomain(for: intVariableA.name, to: [1])
        expectedVariableSet.assign(intVariableC.name, to: 8)

        csp.update(using: expectedVariableSet)

        XCTAssertEqual(csp.variableSet, expectedVariableSet)

        csp.revertToPreviousState()

        let revertedVariableSet = constraintSet.applyUnaryConstraints(to: variableSet)

        XCTAssertEqual(csp.variableSet, revertedVariableSet)
    }

    func testRevertToPreviousState_alreadyAtInitialState_noChange() {
        let initialState = constraintSet.applyUnaryConstraints(to: variableSet)

        for _ in 0 ..< 10 {
            csp.revertToPreviousState()
            XCTAssertEqual(csp.variableSet, initialState)
        }
    }
}
