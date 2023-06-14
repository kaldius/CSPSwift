import XCTest
@testable import CSPSolver

final class LeastConstrainingValueTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!

    var variableSet: VariableSet!

    var aGreaterThanB: GreaterThanConstraint!

    var constraintSet: ConstraintSet!

    var inferenceEngine: InferenceEngine!

    var leastConstrainingValue: LeastConstrainingValue!

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3, 4, 5]))
        intVariableB = IntVariable(name: "intB", domain: Set([3, 4, 5, 6, 7]))

        let allVariables: [any Variable] = [intVariableA, intVariableB]

        variableSet = VariableSet(from: allVariables)

        aGreaterThanB = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)

        let allConstraints: [any Constraint] = [aGreaterThanB]

        constraintSet = ConstraintSet(allConstraints)

        inferenceEngine = ArcConsistency3()

        leastConstrainingValue = LeastConstrainingValue(inferenceEngine: inferenceEngine)
    }

    func testOrderDomainValues() throws {
        let actualValues = try leastConstrainingValue.orderDomainValues(for: intVariableA,
                                                                        state: variableSet,
                                                                        constraintSet: constraintSet)
        let expectedValues = [5, 4]

        XCTAssertEqual(actualValues, expectedValues)
    }
}
