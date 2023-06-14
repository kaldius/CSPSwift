import XCTest
@testable import CSPSolver

final class AuxillaryConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var strVariableC: StringVariable!

    var allAssociatedVariables: [any Variable]!
    var allAssociatedDomains: [[any Value]]!

    var dualVariable: TernaryVariable!
    var expectedDualVariableDomain: Set<NaryVariableValueType>!

    var variableSet: VariableSet!

    var auxillaryConstraintA: AuxillaryConstraint!
    var auxillaryConstraintB: AuxillaryConstraint!
    var auxillaryConstraintC: AuxillaryConstraint!

    var allConstraints: [any Constraint]!

    override func setUpWithError() throws {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        intVariableB = IntVariable(name: "intB", domain: Set([4, 5, 6]))
        strVariableC = StringVariable(name: "strC", domain: Set(["x", "y", "z"]))

        allAssociatedVariables = [intVariableA, intVariableB, strVariableC]
        allAssociatedDomains = [intVariableA.domainAsArray, intVariableB.domainAsArray, strVariableC.domainAsArray]

        dualVariable = TernaryVariable(name: "dual",
                                       variableA: intVariableA,
                                       variableB: intVariableB,
                                       variableC: strVariableC)

        let possibleAssignments = [any Value].possibleAssignments(domains: allAssociatedDomains)
        expectedDualVariableDomain = Set(possibleAssignments.map({ NaryVariableValueType(value: $0) }))

        variableSet = try VariableSet(from: [intVariableA, intVariableB, strVariableC, dualVariable])

        auxillaryConstraintA = AuxillaryConstraint(mainVariable: intVariableA, dualVariable: dualVariable)
        auxillaryConstraintB = AuxillaryConstraint(mainVariable: intVariableB, dualVariable: dualVariable)
        auxillaryConstraintC = AuxillaryConstraint(mainVariable: strVariableC, dualVariable: dualVariable)

        allConstraints = [auxillaryConstraintA, auxillaryConstraintB, auxillaryConstraintC]
    }

    // MARK: Testing methods/attributes inherited from Constraint
    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        for constraint in allConstraints {
            XCTAssertFalse(constraint.containsAssignedVariable(state: variableSet))
        }
    }

    func testContainsAssignedVariable_mainVariableAssigned_returnsTrue() throws {
        // auxillaryConstraintA
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)
        XCTAssertTrue(auxillaryConstraintA.containsAssignedVariable(state: variableSet))

        // auxillaryConstraintB
        try variableSet.assign(intVariableB.name, to: 5)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 5)
        XCTAssertTrue(auxillaryConstraintB.containsAssignedVariable(state: variableSet))

        // auxillaryConstraintC
        try variableSet.assign(strVariableC.name, to: "y")
        let assignmentC = variableSet.getAssignment(strVariableC.name, type: StringVariable.self)
        XCTAssertEqual(assignmentC, "y")
        XCTAssertTrue(auxillaryConstraintC.containsAssignedVariable(state: variableSet))
    }

    func testContainsAssignedVariable_dualVariableAssigned_returnsTrue() throws {
        let newAssignment = NaryVariableValueType(value: [2, 5, "z"])
        try variableSet.assign(dualVariable.name, to: newAssignment)
        XCTAssertTrue(variableSet.isAssigned(dualVariable.name))

        for constraint in allConstraints {
            XCTAssertTrue(constraint.containsAssignedVariable(state: variableSet))
        }
    }

    // MARK: Testing methods/attributes inherited from BinaryConstraint
    func testDependsOn_validVariableName_returnsTrue() {
        XCTAssertTrue(auxillaryConstraintA.depends(on: intVariableA.name))
        XCTAssertTrue(auxillaryConstraintA.depends(on: dualVariable.name))

        XCTAssertTrue(auxillaryConstraintB.depends(on: intVariableB.name))
        XCTAssertTrue(auxillaryConstraintB.depends(on: dualVariable.name))

        XCTAssertTrue(auxillaryConstraintC.depends(on: strVariableC.name))
        XCTAssertTrue(auxillaryConstraintC.depends(on: dualVariable.name))
    }

    func testDependsOn_invalidVariableName_returnsFalse() {
        XCTAssertFalse(auxillaryConstraintA.depends(on: intVariableB.name))
    }

    func testVariableNameOtherThan_validVariableNames_returnsOtherVariableName() {
        var expected = intVariableA.name
        var actual = auxillaryConstraintA.variableName(otherThan: dualVariable.name)
        XCTAssertEqual(actual, expected)

        expected = dualVariable.name
        actual = auxillaryConstraintC.variableName(otherThan: strVariableC.name)
        XCTAssertEqual(actual, expected)
    }

    func testVariableNameOtherThan_invalidVariableName_returnsNil() {
        XCTAssertNil(auxillaryConstraintA.variableName(otherThan: "nonExistentVariableName"))
    }

    // MARK: Testing methods/attributes declared in AuxillaryConstraint
    func testInit_dualVariableNotAssociatedWithMainVariable_returnsNil() {
        let unassociatedVariable = IntVariable(name: "unassociatedVariable", domain: Set([11, 22, 33]))
        let failedAuxillaryConstraint = AuxillaryConstraint(mainVariable: unassociatedVariable,
                                                            dualVariable: dualVariable)
        XCTAssertNil(failedAuxillaryConstraint)
    }

    func testVariableNames_returnsAllVariableNames() {
        for idx in 0 ..< allConstraints.count {
            let constraint = allConstraints[idx]
            let mainVariable = allAssociatedVariables[idx]
            let expectedVariableNames: [String] = [mainVariable.name, dualVariable.name]

            let actualVariableNames = constraint.variableNames

            XCTAssertTrue(actualVariableNames == expectedVariableNames)
        }
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_bothUnassigned_returnsFalse() {
        for constraint in allConstraints {
            XCTAssertFalse(constraint.isSatisfied(state: variableSet))
        }
    }

    func testIsSatisfied_onlyMainVariableAssigned_returnsFalse() throws {
        // auxillaryConstraintA
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)
        XCTAssertFalse(variableSet.isAssigned(dualVariable.name))
        XCTAssertFalse(auxillaryConstraintA.isSatisfied(state: variableSet))

        // auxillaryConstraintB
        try variableSet.assign(intVariableB.name, to: 5)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 5)
        XCTAssertFalse(variableSet.isAssigned(dualVariable.name))
        XCTAssertFalse(auxillaryConstraintB.isSatisfied(state: variableSet))

        // auxillaryConstraintC
        try variableSet.assign(strVariableC.name, to: "y")
        let assignmentC = variableSet.getAssignment(strVariableC.name, type: StringVariable.self)
        XCTAssertEqual(assignmentC, "y")
        XCTAssertFalse(variableSet.isAssigned(dualVariable.name))
        XCTAssertFalse(auxillaryConstraintC.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_onlyDualVariableAssigned_returnsFalse() throws {
        let newAssignment = NaryVariableValueType(value: [1, 6, "y"])
        try variableSet.assign(dualVariable.name, to: newAssignment)
        XCTAssertTrue(variableSet.isAssigned(dualVariable.name))

        for constraint in allConstraints {
            XCTAssertFalse(constraint.isSatisfied(state: variableSet))
        }
    }

    func testIsSatisfied_allVariablesNotEqualDualVariable_allReturnFalse() throws {
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        try variableSet.assign(intVariableB.name, to: 4)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 4)

        try variableSet.assign(strVariableC.name, to: "x")
        let assignmentC = variableSet.getAssignment(strVariableC.name, type: StringVariable.self)
        XCTAssertEqual(assignmentC, "x")

        let newAssignment = NaryVariableValueType(value: [2, 6, "y"])
        try variableSet.assign(dualVariable.name, to: newAssignment)
        let dualVariableAssignment = variableSet.getAssignment(dualVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(dualVariableAssignment, newAssignment)

        for constraint in allConstraints {
            XCTAssertFalse(constraint.isSatisfied(state: variableSet))
        }
    }

    func testIsSatisfied_someVariablesEqualDualVariable_equalAssignmentsReturnTrue() throws {
        try variableSet.assign(intVariableA.name, to: 2)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 2)

        try variableSet.assign(intVariableB.name, to: 4)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 4)

        try variableSet.assign(strVariableC.name, to: "y")
        let assignmentC = variableSet.getAssignment(strVariableC.name, type: StringVariable.self)
        XCTAssertEqual(assignmentC, "y")

        let newAssignment = NaryVariableValueType(value: [2, 6, "y"])
        try variableSet.assign(dualVariable.name, to: newAssignment)
        let dualVariableAssignment = variableSet.getAssignment(dualVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(dualVariableAssignment, newAssignment)

        XCTAssertTrue(auxillaryConstraintA.isSatisfied(state: variableSet))
        XCTAssertFalse(auxillaryConstraintB.isSatisfied(state: variableSet))
        XCTAssertTrue(auxillaryConstraintC.isSatisfied(state: variableSet))
    }

    // MARK: tests for isViolated
    func testIsViolated_bothUnassigned_returnsFalse() {
        for constraint in allConstraints {
            XCTAssertFalse(constraint.isViolated(state: variableSet))
        }
    }

    func testIsViolated_onlyMainVariableAssigned_returnsFalse() throws {
        // auxillaryConstraintA
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)
        XCTAssertFalse(variableSet.isAssigned(dualVariable.name))
        XCTAssertFalse(auxillaryConstraintA.isViolated(state: variableSet))

        // auxillaryConstraintB
        try variableSet.assign(intVariableB.name, to: 5)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 5)
        XCTAssertFalse(variableSet.isAssigned(dualVariable.name))
        XCTAssertFalse(auxillaryConstraintB.isViolated(state: variableSet))

        // auxillaryConstraintC
        try variableSet.assign(strVariableC.name, to: "y")
        let assignmentC = variableSet.getAssignment(strVariableC.name, type: StringVariable.self)
        XCTAssertEqual(assignmentC, "y")
        XCTAssertFalse(variableSet.isAssigned(dualVariable.name))
        XCTAssertFalse(auxillaryConstraintC.isViolated(state: variableSet))
    }

    func testIsViolated_onlyDualVariableAssigned_returnsFalse() throws {
        let newAssignment = NaryVariableValueType(value: [1, 6, "y"])
        try variableSet.assign(dualVariable.name, to: newAssignment)
        XCTAssertTrue(variableSet.isAssigned(dualVariable.name))

        for constraint in allConstraints {
            XCTAssertFalse(constraint.isViolated(state: variableSet))
        }
    }

    func testIsViolated_someVariablesEqualDualVariable_unequalAssignmentsReturnTrue() throws {
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        try variableSet.assign(intVariableB.name, to: 4)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 4)

        try variableSet.assign(strVariableC.name, to: "x")
        let assignmentC = variableSet.getAssignment(strVariableC.name, type: StringVariable.self)
        XCTAssertEqual(assignmentC, "x")

        let newAssignment = NaryVariableValueType(value: [1, 6, "x"])
        try variableSet.assign(dualVariable.name, to: newAssignment)
        let dualVariableAssignment = variableSet.getAssignment(dualVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(dualVariableAssignment, newAssignment)

        XCTAssertFalse(auxillaryConstraintA.isViolated(state: variableSet))
        XCTAssertTrue(auxillaryConstraintB.isViolated(state: variableSet))
        XCTAssertFalse(auxillaryConstraintC.isViolated(state: variableSet))
    }

    func testIsViolated_allVariablesNotEqualDualVariable_allReturnTrue() throws {
        try variableSet.assign(intVariableA.name, to: 1)
        let assignmentA = variableSet.getAssignment(intVariableA.name, type: IntVariable.self)
        XCTAssertEqual(assignmentA, 1)

        try variableSet.assign(intVariableB.name, to: 4)
        let assignmentB = variableSet.getAssignment(intVariableB.name, type: IntVariable.self)
        XCTAssertEqual(assignmentB, 4)

        try variableSet.assign(strVariableC.name, to: "x")
        let assignmentC = variableSet.getAssignment(strVariableC.name, type: StringVariable.self)
        XCTAssertEqual(assignmentC, "x")

        let newAssignment = NaryVariableValueType(value: [2, 6, "y"])
        try variableSet.assign(dualVariable.name, to: newAssignment)
        let dualVariableAssignment = variableSet.getAssignment(dualVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(dualVariableAssignment, newAssignment)

        for constraint in allConstraints {
            XCTAssertTrue(constraint.isViolated(state: variableSet))
        }
    }
}
