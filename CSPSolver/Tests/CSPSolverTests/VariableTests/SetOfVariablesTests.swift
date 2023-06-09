import XCTest
@testable import CSPSolver

// TODO: test cases ending with "throwsError" should be implemented after errors are implemented!!!
final class SetOfVariablesTests: XCTestCase {
    var intVariableA: IntVariable!
    var floatVariableB: FloatVariable!
    var floatVariableC: FloatVariable!

    var ternaryVariable: TernaryVariable!

    var variableSet: SetOfVariables!

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        floatVariableB = FloatVariable(name: "floatB", domain: Set([4.123, 5.456, 6.789]))
        floatVariableC = FloatVariable(name: "floatC", domain: Set([7.987, 8.654, 9.321]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: floatVariableB,
                                          variableC: floatVariableC)

        variableSet = SetOfVariables(from: [intVariableA, floatVariableB, floatVariableC, ternaryVariable])
    }

    // TODO: all testcases
}
