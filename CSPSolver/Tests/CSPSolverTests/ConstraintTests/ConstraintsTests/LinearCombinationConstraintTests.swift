import XCTest
@testable import CSPSolver

final class LinearCombinationConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var floatVariableB: FloatVariable!
    var floatVariableC: FloatVariable!

    var ternaryVariable: TernaryVariable!

    var variableSet: VariableSet!

    var linearCombinationConstraint: LinearCombinationConstraint!

    override func setUpWithError() throws {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        floatVariableB = FloatVariable(name: "floatB", domain: Set([4.123, 5.456, 6.789]))
        floatVariableC = FloatVariable(name: "floatC", domain: Set([7.987, 8.654, 9.321]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: floatVariableB,
                                          variableC: floatVariableC)

        variableSet = try VariableSet(from: [intVariableA, floatVariableB, floatVariableC, ternaryVariable])

        linearCombinationConstraint = LinearCombinationConstraint(ternaryVariable,
                                                                  scaleA: 1,
                                                                  scaleB: 2,
                                                                  scaleC: -1,
                                                                  add: -7.591)
    }
    // MARK: testing methods/attributes inherited from Constraint
    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        XCTAssertFalse(linearCombinationConstraint.containsAssignedVariable(state: variableSet))
    }

    func testContainsAssignedVariable_someAssigned_returnsTrue() throws {
        let floatB: Float = 5.456
        let floatC: Float = 9.321
        let newAssignment = NaryVariableValueType(value: [1, floatB, floatC])
        try variableSet.assign(ternaryVariable.name, to: newAssignment)
        XCTAssertTrue(try variableSet.isAssigned(ternaryVariable.name))

        XCTAssertTrue(linearCombinationConstraint.containsAssignedVariable(state: variableSet))
    }

    // MARK: testing methods/attributes inherited from UnaryConstraint
    func testRestrictDomain_returnsCorrectlyRestrictedDomain() throws {
        let floatB: Float = 6.789
        let floatC: Float = 7.987

        // preparing expected result
        var copiedVariableSet = variableSet!
        let newAssignment = NaryVariableValueType(value: [2, floatB, floatC])
        try copiedVariableSet.assign(ternaryVariable.name, to: newAssignment)
        let expectedTernaryVariableDomain = try copiedVariableSet.getDomain(ternaryVariable.name,
                                                                            type: TernaryVariable.self)

        // getting result
        let restrictedVariableSet = try linearCombinationConstraint.restrictDomain(state: variableSet)
        let actualTernaryVariableDomain = try restrictedVariableSet.getDomain(ternaryVariable.name,
                                                                              type: TernaryVariable.self)

        measure {
            _ = try? linearCombinationConstraint.restrictDomain(state: variableSet)
        }

        XCTAssertEqual(actualTernaryVariableDomain, expectedTernaryVariableDomain)
    }
    
    // MARK: testing methods/attributes inherited from TernaryVariableConstraint
    func testVariableNames_returnsAllVariableNames() {
        let expectedVariableNames: [String] = [ternaryVariable.name]
        let actualVariableNames = linearCombinationConstraint.variableNames
        XCTAssertTrue(actualVariableNames == expectedVariableNames)
    }

    // MARK: testing methods/attributes declared in LinearCombinationConstraint
    // MARK: tests for isSatisfied
    func testIsSatisfied_unassigned_returnsFalse() {
        XCTAssertFalse(try linearCombinationConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_doesNotSatisfyLinearCombination_returnsFalse() throws {
        let floatB: Float = 4.123
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [1, floatB, floatC])
        try variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = try variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertFalse(try linearCombinationConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_satisfiesLinearCombination_returnsTrue() throws {
        let floatB: Float = 6.789
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [2, floatB, floatC])
        try variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = try variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertTrue(try linearCombinationConstraint.isSatisfied(state: variableSet))
    }

    // MARK: tests for isViolated
    func testIsViolated_unassigned_returnsFalse() {
        XCTAssertFalse(try linearCombinationConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_satisfiesLinearCombination_returnsFalse() throws {
        let floatB: Float = 6.789
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [2, floatB, floatC])
        try variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = try variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertFalse(try linearCombinationConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_doesNotSatisfyLinearCombination_returnsTrue() throws {
        let floatB: Float = 4.123
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [1, floatB, floatC])
        try variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = try variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertTrue(try linearCombinationConstraint.isViolated(state: variableSet))
    }
}
