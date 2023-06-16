import XCTest
@testable import CSPSolver

final class TernaryVariableTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!

    var allAssociatedVariables: [any Variable]!
    var allAssociatedDomains: [[any Value]]!

    var ternaryVariable: TernaryVariable!
    var ternaryVariableDomain: Set<NaryVariableValueType>!

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
        ternaryVariableDomain = Set(possibleAssignments.map({ NaryVariableValueType(value: $0) }))
    }

    // MARK: Testing methods/attributes declared in TernaryVariable
    func testDomain_returnsCorrectDomain() {
        XCTAssertEqual(ternaryVariable.domain, ternaryVariableDomain)
    }

    func testDomain_variableAssigned_returnsOnlyOneValue() {
        let assignment = NaryVariableValueType(value: [1, 4, 8])
        XCTAssertNoThrow(try ternaryVariable.assign(to: assignment))
        XCTAssertEqual(ternaryVariable.domain, [assignment])
    }

    func testAssignment_initialAssignment_returnsNil() {
        XCTAssertNil(ternaryVariable.assignment)
    }

    func testAssignTo_possibleValue_correctlyAssigned() throws {
        for domainValue in ternaryVariableDomain {
            XCTAssertNoThrow(try ternaryVariable.assign(to: domainValue))
            let assignment = try XCTUnwrap(ternaryVariable.assignment)
            XCTAssertEqual(assignment, domainValue)
            ternaryVariable.unassign()
        }
    }

    func testAssignTo_variableCurrentlyAssigned_throwsError() {
        let assignment = NaryVariableValueType(value: [1, 4, 8])
        let otherAssignment = NaryVariableValueType(value: [1, 5, 9])
        XCTAssertNoThrow(try ternaryVariable.assign(to: assignment))
        XCTAssertThrowsError(try ternaryVariable.assign(to: otherAssignment),
                             "Should throw overwritingExistingAssignmentError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.overwritingExistingAssignmentError) })
        XCTAssertEqual(ternaryVariable.assignment, assignment)
    }

    func testAssignTo_valueNotInDomain_throwsError() {
        let valueNotInDomain = NaryVariableValueType(value: [1, 4, 10])
        XCTAssertThrowsError(try ternaryVariable.assign(to: valueNotInDomain),
                             "Should throw assignmentNotInDomainError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.assignmentNotInDomainError) })
        XCTAssertNil(ternaryVariable.assignment)
        // assign to 3 passes
        let valueInDomain = NaryVariableValueType(value: [1, 4, 8])
        XCTAssertNoThrow(try ternaryVariable.assign(to: valueInDomain))
    }

    func testSetDomainTo_validNewDomain_setsDomainCorrectly() {
        let newDomainAsArray: [[any Value]] = [[1, 4, 9], [2, 5, 8]]
        let newDomain = Set(newDomainAsArray.map({ NaryVariableValueType(value: $0) }))
        XCTAssertNoThrow(try ternaryVariable.setDomain(to: newDomain))

        XCTAssertEqual(ternaryVariable.domain, newDomain)
    }

    func testSetDomainTo_emptyDomain_setsDomainCorrectly() {
        let newDomain: Set<NaryVariableValueType> = Set()
        XCTAssertNoThrow(try ternaryVariable.setDomain(to: newDomain))

        XCTAssertEqual(ternaryVariable.domain.count, 0)
    }

    func testSetDomainTo_notSubsetOfCurrentDomain_throwsError() {
        var newDomain: Set<NaryVariableValueType> = ternaryVariableDomain
        let extraDomainValue = NaryVariableValueType(value: [10, 6, "a"])
        newDomain.insert(extraDomainValue)

        XCTAssertThrowsError(try ternaryVariable.setDomain(to: newDomain),
                             "Should throw incompatibleDomainError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.incompatibleDomainError) })
    }

    func testUnassign_assignmentSetToNil() {
        let newAssignment = NaryVariableValueType(value: [1, 4, 7])
        XCTAssertNoThrow(try ternaryVariable.assign(to: newAssignment))
        XCTAssertEqual(ternaryVariable.assignment, newAssignment)
        ternaryVariable.unassign()
        XCTAssertNil(ternaryVariable.assignment)
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
            XCTAssertNoThrow(try ternaryVariable.assign(to: domainValue))
            for associatedVariable in allAssociatedVariables {
                // associatedVariable remains unassigned
                XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentSatisfied_ternaryVariableUnassigned_mainVariableAssigned_returnsFalse() {
        // ternayVariable remains unassigned
        for associatedVariable in allAssociatedVariables {
            var copiedAssociatedVariable = associatedVariable
            for domainValue in associatedVariable.domainAsArray {
                // assign associatedVariable
                XCTAssertTrue(associatedVariable.canAssign(to: domainValue))
                XCTAssertNoThrow(try copiedAssociatedVariable.assign(to: domainValue))
                XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
                copiedAssociatedVariable.unassign()
            }
        }
    }

    func testAssignmentSatisfied_bothAssignedDifferently_returnsFalse() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            XCTAssertNoThrow(try ternaryVariable.assign(to: ternaryVarDomainValue))
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                for associatedVarDomainValue in associatedVar.domainAsArray
                where !associatedVarDomainValue.isEqual(ternaryVarDomainValue[idx]) {
                    // assign associatedVariable (but only with some value not equal to ternaryVarDomainValue[idx])
                    XCTAssertTrue(associatedVar.canAssign(to: associatedVarDomainValue))
                    XCTAssertNoThrow(try associatedVar.assign(to: associatedVarDomainValue))
                    XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVar))
                    associatedVar.unassign()
                }
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentSatisfied_bothAssignedSame_returnsTrue() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            XCTAssertNoThrow(try ternaryVariable.assign(to: ternaryVarDomainValue))
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                let correctAssociatedVarAssignment = ternaryVarDomainValue[idx]
                // assign associatedVariable (but only with ternaryVarDomainValue[idx])
                XCTAssertTrue(associatedVar.canAssign(to: correctAssociatedVarAssignment))
                XCTAssertNoThrow(try associatedVar.assign(to: correctAssociatedVarAssignment))
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
            XCTAssertNoThrow(try ternaryVariable.assign(to: domainValue))
            for associatedVariable in allAssociatedVariables {
                // associatedVariable remains unassigned
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_ternaryVariableUnassigned_mainVariableAssigned_returnsFalse() {
        // ternayVariable remains unassigned
        for associatedVariable in allAssociatedVariables {
            var copiedAssociatedVariable = associatedVariable
            for domainValue in associatedVariable.domainAsArray {
                // assign associatedVariable
                XCTAssertTrue(associatedVariable.canAssign(to: domainValue))
                XCTAssertNoThrow(try copiedAssociatedVariable.assign(to: domainValue))
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
                copiedAssociatedVariable.unassign()
            }
        }
    }

    func testAssignmentViolated_bothAssignedSame_returnsFalse() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            XCTAssertNoThrow(try ternaryVariable.assign(to: ternaryVarDomainValue))
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                let correctAssociatedVarAssignment = ternaryVarDomainValue[idx]
                // assign associatedVariable (but only with ternaryVarDomainValue[idx])
                XCTAssertTrue(associatedVar.canAssign(to: correctAssociatedVarAssignment))
                XCTAssertNoThrow(try associatedVar.assign(to: correctAssociatedVarAssignment))
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVar))
                associatedVar.unassign()
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_bothAssignedDifferently_returnsTrue() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            XCTAssertNoThrow(try ternaryVariable.assign(to: ternaryVarDomainValue))
            for idx in 0 ..< allAssociatedVariables.count {
                var associatedVar = allAssociatedVariables[idx]
                for associatedVarDomainValue in associatedVar.domainAsArray
                where !associatedVarDomainValue.isEqual(ternaryVarDomainValue[idx]) {
                    // assign associatedVariable (but only with some value not equal to ternaryVarDomainValue[idx])
                    XCTAssertTrue(associatedVar.canAssign(to: associatedVarDomainValue))
                    XCTAssertNoThrow(try associatedVar.assign(to: associatedVarDomainValue))
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

    func testGetAssociatedDomains() {
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
    func testAssignToAnyValue_wrongValueType_throwsError() {
        XCTAssertThrowsError(try ternaryVariable.assign(to: "success"),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
        XCTAssertThrowsError(try ternaryVariable.assign(to: true),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
        XCTAssertThrowsError(try ternaryVariable.assign(to: 3),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })
    }

    func testCanAssign_possibleValue_returnsTrue() {
        for domainValue in ternaryVariableDomain {
            XCTAssertTrue(ternaryVariable.canAssign(to: domainValue))
        }
    }

    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(ternaryVariable.canAssign(to: 4))
        XCTAssertFalse(ternaryVariable.canAssign(to: "success"))
        XCTAssertFalse(ternaryVariable.canAssign(to: true))
        let wrongNaryVariableValueType = NaryVariableValueType(value: ["a", 5, 8])
        XCTAssertFalse(ternaryVariable.canAssign(to: wrongNaryVariableValueType))
    }

    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomainAsArray: [[any Value]] = [[1, 4, 9], [2, 5, 8]]
        let newDomain = newDomainAsArray.map({ NaryVariableValueType(value: $0) })
        XCTAssertTrue(ternaryVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [Int]()
        XCTAssertTrue(ternaryVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_notSubsetOfCurrentDomain_returnsFalse() {
        var newDomain = Array(ternaryVariableDomain)
        let extraDomainValue = NaryVariableValueType(value: [10, 6, "a"])
        newDomain.append(extraDomainValue)

        XCTAssertFalse(ternaryVariable.canSetDomain(to: newDomain))
    }

    func testSetDomainToAnyValue_validNewDomain_setsDomainCorrectly() {
        let newDomainAsArray: [[any Value]] = [[1, 4, 9], [2, 5, 8]]
        let newDomain = newDomainAsArray.map({ NaryVariableValueType(value: $0) })
        XCTAssertNoThrow(try ternaryVariable.setDomain(to: newDomain))

        XCTAssertEqual(ternaryVariable.domain, Set(newDomain))
    }

    func testSetDomainToAnyValue_emptyDomain_setsDomainCorrectly() {
        let newDomain: [any Value] = []
        XCTAssertNoThrow(try ternaryVariable.setDomain(to: newDomain))

        XCTAssertEqual(ternaryVariable.domain.count, 0)
    }

    func testSetDomainToAnyValue_wrongValueType_throwsError() {
        let newDomain = ["a", "b", "c"]
        XCTAssertThrowsError(try ternaryVariable.setDomain(to: newDomain),
                             "Should throw valueTypeError",
                             { XCTAssertEqual($0 as? VariableError, VariableError.valueTypeError) })

        XCTAssertEqual(ternaryVariable.domain, ternaryVariableDomain)
    }
}
