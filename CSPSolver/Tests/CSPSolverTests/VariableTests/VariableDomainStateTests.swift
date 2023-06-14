import XCTest
@testable import CSPSolver

/*
final class VariableDomainStateTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!

    var stringVariableDomain: Set<String>!
    var stringVariable: StringVariable!

    var floatVariableDomain: Set<Float>!
    var floatVariable: FloatVariable!

    var ternaryVariable: TernaryVariable!

    var variableDomainState: VariableDomainState!

    override func setUp() {
        super.setUp()
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)

        stringVariableDomain = ["a", "b", "c"]
        stringVariable = StringVariable(name: "string", domain: stringVariableDomain)

        floatVariableDomain = [1.987, 2.654, 3.321]
        floatVariable = FloatVariable(name: "float", domain: floatVariableDomain)

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariable,
                                          variableB: stringVariable,
                                          variableC: floatVariable)

        variableDomainState = VariableDomainState()
        variableDomainState.addDomain(for: intVariable, domain: Array(intVariableDomain))
        variableDomainState.addDomain(for: stringVariable, domain: Array(stringVariableDomain))
        variableDomainState.addDomain(for: floatVariable, domain: Array(floatVariableDomain))
        variableDomainState.addDomain(for: ternaryVariable, domain: Array(ternaryVariable.domain))
    }

    func testInitFromVariables() {
        let newState = VariableDomainState(from: [intVariable, stringVariable, floatVariable, ternaryVariable])
        XCTAssertEqual(newState, variableDomainState)
    }

    func testContainsEmptyDomain_allVariablesHaveNonEmptyDomains_returnsFalse() {
        XCTAssertFalse(variableDomainState.containsEmptyDomain)
    }

    func testContainsEmptyDomain_includesVariableWithEmptyDomain_returnsTrue() {
        let emptyDomain = Set<Int>()
        let testIntVariable = IntVariable(name: "test", domain: emptyDomain)
        variableDomainState.addDomain(for: testIntVariable, domain: Array(emptyDomain))
        XCTAssertTrue(variableDomainState.containsEmptyDomain)
    }

    func testNumConsistentDomainValues() {
        var expectedValue = intVariable.domainSize
                          + stringVariable.domainSize
                          + floatVariable.domainSize
                          + ternaryVariable.domainSize
        var actualValue = variableDomainState.numConsistentDomainValues
        XCTAssertEqual(actualValue, expectedValue)

        // reduce intVariable domain size (from 3 to 2)
        let newIntVariableDomain = Set([1, 2])
        variableDomainState.addDomain(for: intVariable, domain: Array(newIntVariableDomain))
        expectedValue -= 1
        actualValue = variableDomainState.numConsistentDomainValues
        XCTAssertEqual(actualValue, expectedValue)

        // reduce ternaryVariable domain size (from 27 to 2)
        let ternaryVariableDomainValueA: [any Value] = [1, "a", Float(1.987)]
        let ternaryVariableDomainValueB: [any Value] = [2, "c", Float(1.987)]
        let newTernaryVariableDomain = Set([ternaryVariableDomainValueA, ternaryVariableDomainValueB]
            .map({ NaryVariableValueType(value: $0) }))
        variableDomainState.addDomain(for: ternaryVariable, domain: Array(newTernaryVariableDomain))
        expectedValue -= 25
        actualValue = variableDomainState.numConsistentDomainValues
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testAddDomainAndGetDomain_overwritesPreviousValue() throws {
        let newIntVariableDomain = [1, 2]
        variableDomainState.addDomain(for: intVariable, domain: Array(newIntVariableDomain))
        let newInferredIntDomainAsArray = try XCTUnwrap(variableDomainState.getDomain(for: intVariable))
        XCTAssertTrue(newInferredIntDomainAsArray.containsSameValues(as: newIntVariableDomain))

        let ternaryVariableDomainValueA: [any Value] = [1, "a", Float(1.987)]
        let ternaryVariableDomainValueB: [any Value] = [2, "c", Float(1.987)]
        let newTernaryVariableDomain = [ternaryVariableDomainValueA, ternaryVariableDomainValueB]
            .map({ NaryVariableValueType(value: $0) })
        variableDomainState.addDomain(for: ternaryVariable, domain: Array(newTernaryVariableDomain))
        let newInferredTernaryDomainAsArray = try XCTUnwrap(variableDomainState.getDomain(for: ternaryVariable))
        XCTAssertTrue(newInferredTernaryDomainAsArray.containsSameValues(as: newTernaryVariableDomain))
    }

    func testAddDomain_invalidDomain_throwsError() {
        // TODO: implement after errors are implemented
    }

    func testGetDomain_getsValueCorrectly() throws {
        let inferredDomain = try XCTUnwrap(variableDomainState.getDomain(for: intVariable))
        XCTAssertTrue(inferredDomain.containsSameValues(as: Array(intVariableDomain)))
    }

    func testGetDomain_nonexistentDomain_returnsNil() {
        let nonExistentVariable = IntVariable(name: "nonExistentVariable", domain: [100])
        let inferredDomain = variableDomainState.getDomain(for: nonExistentVariable)
        XCTAssertNil(inferredDomain)
    }
}
*/
