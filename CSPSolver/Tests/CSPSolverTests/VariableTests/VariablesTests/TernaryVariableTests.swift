import XCTest
@testable import CSPSolver

final class TernaryVariableTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!

    var allAssociatedVariables: [any Variable]!
    var allAssociatedDomains: [[any Value]]!

    var ternaryVariable: TernaryVariable!
    var expectedTernaryVariableDomain: Set<NaryVariableValueType>!

    override func setUp() {
        super.setUp()
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        intVariableB = IntVariable(name: "intB", domain: Set([4, 5, 6]))
        intVariableC = IntVariable(name: "intC", domain: Set([7, 8, 9]))

        allAssociatedVariables = [intVariableA, intVariableB, intVariableC]
        allAssociatedDomains = [intVariableA.domainAsArray, intVariableB.domainAsArray, intVariableC.domainAsArray]

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: intVariableB,
                                          variableC: intVariableC)

        let possibleAssignments = [any Value].possibleAssignments(domains: allAssociatedDomains)
        expectedTernaryVariableDomain = Set(possibleAssignments.map({ NaryVariableValueType(value: $0) }))
    }

    // MARK: Testing methods/attributes inherited from NaryVariable
    func testIsAssociated_associatedVariable_returnsTrue() {
        for associatedVariable in allAssociatedVariables {
            XCTAssertTrue(ternaryVariable.isAssociated(with: associatedVariable))
        }
    }

    func testIsAssociated_nonAssociatedVariable_returnsFalse() {
        let nonAssociatedVariable = IntVariable(name: "nonAssociatedInt", domain: Set([7, 8, 9]))
        XCTAssertFalse(ternaryVariable.isAssociated(with: nonAssociatedVariable))
    }

    func testAssignmentSatisfied_nonAssociatedVariable_returnsFalse() {
        let nonAssociatedVariable = IntVariable(name: "nonAssociatedInt", domain: Set([7, 8, 9]))
        XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: nonAssociatedVariable))
    }

    func testAssignmentSatisfied_bothUnassigned_returnsFalse() {
        for associatedVariable in allAssociatedVariables {
            XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
        }
    }

    func testAssignmentSatisfied_ternaryVariableAssigned_mainVariableUnassigned_returnsFalse() {
        for domainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = domainValue
            for associatedVariable in allAssociatedVariables {
                // associatedVariable remains unassigned
                XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentSatisfied_ternaryVariableUnassigned_mainVariableAssigned_returnsFalse() throws {
        // ternayVariable remains unassigned
        for associatedVariable in allAssociatedVariables {
            var copiedAssociatedVariable = associatedVariable
            for domainValue in associatedVariable.domainAsArray {
                // assign associatedVariable
                XCTAssertTrue(associatedVariable.canAssign(to: domainValue))
                try copiedAssociatedVariable.assign(to: domainValue)
                XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
                copiedAssociatedVariable.unassign()
            }
        }
    }

    func testAssignmentSatisfied_bothAssignedDifferently_returnsFalse() throws {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                for associatedVarDomainValue in associatedVar.domainAsArray
                where !associatedVarDomainValue.isEqual(ternaryVarDomainValue[idx]) {
                    // assign associatedVariable (but only with some value not equal to ternaryVarDomainValue[idx])
                    XCTAssertTrue(associatedVar.canAssign(to: associatedVarDomainValue))
                    try associatedVar.assign(to: associatedVarDomainValue)
                    XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVar))
                    associatedVar.unassign()
                }
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentSatisfied_bothAssignedSame_returnsTrue() throws {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                let correctAssociatedVarAssignment = ternaryVarDomainValue[idx]
                // assign associatedVariable (but only with ternaryVarDomainValue[idx])
                XCTAssertTrue(associatedVar.canAssign(to: correctAssociatedVarAssignment))
                try associatedVar.assign(to: correctAssociatedVarAssignment)
                XCTAssertTrue(ternaryVariable.assignmentSatisfied(for: associatedVar))
                associatedVar.unassign()
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_nonAssociatedVariable_returnsFalse() {
        let nonAssociatedVariable = IntVariable(name: "nonAssociatedInt", domain: Set([7, 8, 9]))
        XCTAssertFalse(ternaryVariable.assignmentViolated(for: nonAssociatedVariable))
    }

    func testAssignmentViolated_bothUnassigned_returnsFalse() {
        for associatedVariable in allAssociatedVariables {
            XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
        }
    }

    func testAssignmentViolated_ternaryVariableAssigned_mainVariableUnassigned_returnsFalse() {
        for domainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = domainValue
            for associatedVariable in allAssociatedVariables {
                // associatedVariable remains unassigned
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_ternaryVariableUnassigned_mainVariableAssigned_returnsFalse() throws {
        // ternayVariable remains unassigned
        for associatedVariable in allAssociatedVariables {
            var copiedAssociatedVariable = associatedVariable
            for domainValue in associatedVariable.domainAsArray {
                // assign associatedVariable
                XCTAssertTrue(associatedVariable.canAssign(to: domainValue))
                try copiedAssociatedVariable.assign(to: domainValue)
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
                copiedAssociatedVariable.unassign()
            }
        }
    }

    func testAssignmentViolated_bothAssignedSame_returnsFalse() throws {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                let correctAssociatedVarAssignment = ternaryVarDomainValue[idx]
                // assign associatedVariable (but only with ternaryVarDomainValue[idx])
                XCTAssertTrue(associatedVar.canAssign(to: correctAssociatedVarAssignment))
                try associatedVar.assign(to: correctAssociatedVarAssignment)
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVar))
                associatedVar.unassign()
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_bothAssignedDifferently_returnsTrue() throws {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                for associatedVarDomainValue in associatedVar.domainAsArray
                where !associatedVarDomainValue.isEqual(ternaryVarDomainValue[idx]) {
                    // assign associatedVariable (but only with some value not equal to ternaryVarDomainValue[idx])
                    XCTAssertTrue(associatedVar.canAssign(to: associatedVarDomainValue))
                    try associatedVar.assign(to: associatedVarDomainValue)
                    XCTAssertTrue(ternaryVariable.assignmentViolated(for: associatedVar))
                    associatedVar.unassign()
                }
            }
            ternaryVariable.unassign()
        }
    }

    func testCreateInternalDomain() {
        let associatedDomainA: [any Value] = [1, 2]
        let associatedDomainB: [any Value] = [4, 5]
        let associatedDomainC: [any Value] = ["x", "y"]

        let associatedDomains: [[any Value]] = [associatedDomainA, associatedDomainB, associatedDomainC]

        let possibleAssignments: [[any Value]] = [[1, 4, "x"],
                                                  [1, 4, "y"],
                                                  [1, 5, "x"],
                                                  [1, 5, "y"],
                                                  [2, 4, "x"],
                                                  [2, 4, "y"],
                                                  [2, 5, "x"],
                                                  [2, 5, "y"]]

        let expectedDomain = Set(possibleAssignments.map({ NaryVariableValueType(value: $0) }))
        let actualDomain = TernaryVariable.createInternalDomain(from: associatedDomains)

        XCTAssertEqual(actualDomain, expectedDomain)
    }

    func testGetAssociatedDomains() throws {
        let intVariableD = IntVariable(name: "intD", domain: Set([11, 22, 33]))
        let intVariableE = IntVariable(name: "intE", domain: Set([44, 55, 66]))
        let intVariableF = IntVariable(name: "intF", domain: Set([77, 88, 99]))
        let newAssociatedVariables: [any Variable] = [intVariableD, intVariableE, intVariableF]

        let expectedAssociatedDomains: [[any Value]] = [[11, 22, 33], [44, 55, 66], [77, 88, 99]]
        let actualAssociatedDomains = TernaryVariable.getAssociatedDomains(from: newAssociatedVariables)

        XCTAssertEqual(actualAssociatedDomains.count, expectedAssociatedDomains.count)
        for idx in 0 ..< expectedAssociatedDomains.count {
            // swiftlint:disable force_cast
            let expected = Set(expectedAssociatedDomains[idx] as! [Int])
            let actual = Set(actualAssociatedDomains[idx] as! [Int])
            // swiftlint:enable force_cast
            XCTAssertEqual(actual, expected)
        }
    }

    // MARK: Testing methods/attributes inherited from Variable
    func testDomain_getter() {
        XCTAssertEqual(ternaryVariable.domain, expectedTernaryVariableDomain)
    }

    func testDomain_getter_variableAssigned_returnsOnlyOneValue() {
        let assignment = NaryVariableValueType(value: [1, 4, 8])
        ternaryVariable.assignment = assignment
        XCTAssertEqual(ternaryVariable.domain, [assignment])
    }

    func testDomain_setter_validNewDomain_setsDomainCorrectly() {
        let newDomainAsArray: [[any Value]] = [[1, 4, 9], [2, 5, 8]]
        let newDomain = Set(newDomainAsArray.map({ NaryVariableValueType(value: $0) }))
        ternaryVariable.domain = newDomain

        XCTAssertEqual(ternaryVariable.domain, newDomain)
    }

    func testDomain_setter_notSubsetOfCurrentDomain_throwsError() {

    }

    func testAssignment_getter_initialAssignmentNil() {
        XCTAssertNil(ternaryVariable.assignment)
    }

    func testAssignment_setter_validNewAssignment() {
        for domainValue in expectedTernaryVariableDomain {
            ternaryVariable.unassign()
            ternaryVariable.assignment = domainValue
            XCTAssertEqual(ternaryVariable.assignment, domainValue)
        }
    }

    func testAssignment_setter_currentAssignmentNotNil_throwsError() {

    }

    func testAssignment_setter_newAssignmentNotInDomain_throwsError() {

    }

    func testCanAssign_possibleValue_returnsTrue() {
        for domainValue in expectedTernaryVariableDomain {
            XCTAssertTrue(ternaryVariable.canAssign(to: domainValue))
        }
    }

    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(ternaryVariable.canAssign(to: 4))
        XCTAssertFalse(ternaryVariable.canAssign(to: "success"))
        XCTAssertFalse(ternaryVariable.canAssign(to: true))
        // too many values
        XCTAssertFalse(ternaryVariable.canAssign(to: NaryVariableValueType(value: [1, 4, "x", 10])))
        // first value not in intVariableA's domain
        XCTAssertFalse(ternaryVariable.canAssign(to: NaryVariableValueType(value: [4, 4, "x"])))
    }

    func testAssignTo_possibleValue_getsAssigned() throws {
        for domainValue in expectedTernaryVariableDomain {
            ternaryVariable.unassign()
            try ternaryVariable.assign(to: domainValue)
            let assignment = try XCTUnwrap(ternaryVariable.assignment)
            XCTAssertEqual(assignment, domainValue)
        }
    }

    func testAssignTo_impossibleValue_throwsError() throws {
        /*
        // throws error
        ternaryVariable.assign(to: NaryVariableValueType(value: [1, 4, "a"]))
        XCTAssertNil(ternaryVariable.assignment)
        ternaryVariable.assign(to: NaryVariableValueType(value: [1, 5, "y"]))
        // throws error
        ternaryVariable.assign(to: NaryVariableValueType(value: [5, 5, "x"]))
        let actualValue = try XCTUnwrap(ternaryVariable.assignment)
        XCTAssertEqual(actualValue, NaryVariableValueType(value: [1, 5, "y"]))
         */
    }

    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomainAsArray: [[any Value]] = [[1, 4, 7], [2, 5, 9]]
        let newDomain = newDomainAsArray.map({ NaryVariableValueType(value: $0) })

        XCTAssertTrue(ternaryVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [NaryVariableValueType]()
        XCTAssertTrue(ternaryVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_notSubsetOfCurrentDomain_returnsFalse() {
        var newDomain: Set<NaryVariableValueType> = expectedTernaryVariableDomain
        let extraDomainValue = NaryVariableValueType(value: [10, 6, "a"])
        newDomain.insert(extraDomainValue)

        XCTAssertFalse(ternaryVariable.canSetDomain(to: Array(newDomain)))
    }

    func testSetDomain_validNewDomain_setsDomainCorrectly() {
        let newDomainAsArray: [[any Value]] = [[1, 4, 9], [2, 5, 8]]
        let newDomain = newDomainAsArray.map({ NaryVariableValueType(value: $0) })
        ternaryVariable.setDomain(to: newDomain)
        let expectedDomain = Set(newDomain)

        XCTAssertEqual(ternaryVariable.domain, expectedDomain)
    }

    func testSetDomain_emptyDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = []
        ternaryVariable.setDomain(to: newDomain)

        XCTAssertEqual(ternaryVariable.domain.count, 0)
    }

    func testSetDomain_wrongValueType_throwsError() {

    }

    func testUnassign_assignmentSetToNil() throws {
        let newAssignment = NaryVariableValueType(value: [1, 4, 7])
        ternaryVariable.assignment = newAssignment
        let actualAssignment = try XCTUnwrap(ternaryVariable.assignment)
        XCTAssertEqual(actualAssignment, newAssignment)
        ternaryVariable.unassign()
        XCTAssertNil(ternaryVariable.assignment)
    }
}
