import XCTest
@testable import CSPSolver

final class MinimumRemainingValuesTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!
    var ternaryVariable: TernaryVariable!

    var variableSet: VariableSet!

    var minimumRemainingValues: MinimumRemainingValues!

    override func setUpWithError() throws {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3, 4]))
        intVariableB = IntVariable(name: "intB", domain: Set([3, 4, 5]))
        intVariableC = IntVariable(name: "intC", domain: Set([5, 6, 7, 8, 9]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: intVariableB,
                                          variableC: intVariableC)

        let allVariables: [any Variable] = [intVariableA, intVariableB, intVariableC, ternaryVariable]

        variableSet = try VariableSet(from: allVariables)

        minimumRemainingValues = MinimumRemainingValues()
    }

    func testNextUnassignedVariable() throws {
        let selectedVariable = try XCTUnwrap(minimumRemainingValues.nextUnassignedVariable(state: variableSet))
        XCTAssertEqual(selectedVariable.name, intVariableB.name)
    }

    func testNextUnassignedVariable_afterChangingDomain() throws {
        try variableSet.setDomain(for: ternaryVariable.name, to: [NaryVariableValueType(value: [1, 3, 5])])

        let selectedVariable = try XCTUnwrap(minimumRemainingValues.nextUnassignedVariable(state: variableSet))
        XCTAssertEqual(selectedVariable.name, ternaryVariable.name)
    }
}
