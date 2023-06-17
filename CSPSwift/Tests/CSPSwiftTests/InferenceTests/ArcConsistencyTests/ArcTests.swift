import XCTest
@testable import CSPSwift

final class ArcTests: XCTestCase {
    var intVariableADomain: Set<Int>!
    var intVariableA: IntVariable!
    var intVariableBDomain: Set<Int>!
    var intVariableB: IntVariable!

    var variableSet: VariableSet!

    var aEqualToB: EqualToConstraint!
    var aGreaterThanB: GreaterThanConstraint!

    var arcAEqualToB: Arc!
    var arcBEqualToA: Arc!

    var arcAGreaterThanB: Arc!
    var arcBLessThanA: Arc!

    override func setUpWithError() throws {
        intVariableADomain = Set([1, 2, 3, 4, 5])
        intVariableA = IntVariable(name: "intA", domain: intVariableADomain)
        intVariableBDomain = Set([3, 4, 5, 6, 7])
        intVariableB = IntVariable(name: "intB", domain: intVariableBDomain)

        variableSet = try VariableSet(from: [intVariableA, intVariableB])

        aEqualToB = EqualToConstraint(intVariableA, isEqualTo: intVariableB)
        aGreaterThanB = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)

        arcAEqualToB = Arc(from: aEqualToB, variableIName: intVariableA.name)
        arcBEqualToA = Arc(from: aEqualToB, variableIName: intVariableB.name)

        arcAGreaterThanB = Arc(from: aGreaterThanB, variableIName: intVariableA.name)
        arcBLessThanA = Arc(from: aGreaterThanB, variableIName: intVariableB.name)
    }

    func testInitFromBinaryConstraint_ableToReverseNameOrder() {
        let newArc = Arc(from: aEqualToB, reverse: false)
        var expectedVariableNames = [intVariableA.name, intVariableB.name]

        let actualVariableIName = newArc.variableIName
        let actualVariableJName = newArc.variableJName

        // We do not know which variable will be I or J, so after
        // testing the first one, remove it and test again
        XCTAssertTrue(expectedVariableNames.contains(where: { $0 == actualVariableIName }))
        expectedVariableNames.removeAll(where: { $0 == actualVariableIName })
        XCTAssertTrue(expectedVariableNames.contains(where: { $0 == actualVariableJName }))


        let reversedArc = Arc(from: aEqualToB, reverse: true)

        let reversedVariableIName = reversedArc.variableIName
        let reversedVariableJName = reversedArc.variableJName

        XCTAssertEqual(reversedVariableIName, actualVariableJName)
        XCTAssertEqual(reversedVariableJName, actualVariableIName)
    }

    func testInitWithVariableIName_constraintDoesNotDependOnVariable_returnsNil() {
        let newConstraint = EqualToConstraint(intVariableA, isEqualTo: intVariableA)
        let invalidArc = Arc(from: newConstraint, variableIName: intVariableB.name)
        XCTAssertNil(invalidArc)
    }

    func testInitWithVariableIName_correctlyInitializedValues() throws {
        let newArc = try XCTUnwrap(Arc(from: aEqualToB, variableIName: intVariableA.name))
        XCTAssertEqual(newArc.variableIName, intVariableA.name)
        XCTAssertEqual(newArc.variableJName, intVariableB.name)

        let reversedArc = try XCTUnwrap(Arc(from: aEqualToB, variableIName: intVariableB.name))
        XCTAssertEqual(reversedArc.variableIName, intVariableB.name)
        XCTAssertEqual(reversedArc.variableJName, intVariableA.name)
    }

    func testInitFromAnyConstraint_nonBinaryConstraint_returnsNil() {
        let newVariable = StringVariable(name: "string", domain: Set(["a", "b", "c"]))
        let ternaryVariable = TernaryVariable(name: "ternary",
                                              variableA: newVariable,
                                              variableB: intVariableA,
                                              variableC: intVariableB)
        let nonBinaryConstraint = LinearCombinationConstraint(ternaryVariable,
                                                              scaleA: 1,
                                                              scaleB: 1,
                                                              scaleC: 1)

        let invalidArc = Arc(from: nonBinaryConstraint)
        XCTAssertNil(invalidArc)
    }

    func testContains() {
        XCTAssertTrue(arcAEqualToB.contains(intVariableA.name))
        XCTAssertTrue(arcAEqualToB.contains(intVariableB.name))

        XCTAssertFalse(arcAEqualToB.contains("nonExistentVariableName"))
    }

    func testRevise_variableIAssigned_noRevisionReturned() throws {
        try variableSet.assign(intVariableA.name, to: 4)
        let expectedNilValue = try arcAEqualToB.revise(state: variableSet)
        XCTAssertNil(expectedNilValue)
    }

    func testRevise_reviseArcAEqualToB_correctRevisionReturned() throws {
        let revisedADomain = try XCTUnwrap(arcAEqualToB.revise(state: variableSet))
        let expectedADomain = [3, 4, 5]

        XCTAssertTrue(revisedADomain.containsSameValues(as: expectedADomain))
    }

    func testRevise_reviseArcBEqualToA_correctRevisionReturned() throws {
        let revisedBDomain = try XCTUnwrap(arcBEqualToA.revise(state: variableSet))
        let expectedBDomain = [3, 4, 5]

        XCTAssertTrue(revisedBDomain.containsSameValues(as: expectedBDomain))
    }

    func testRevise_reviseArcAGreaterThanB_correctRevisionReturned() throws {
        let revisedADomain = try XCTUnwrap(arcAGreaterThanB.revise(state: variableSet))
        let expectedADomain = [4, 5]

        XCTAssertTrue(revisedADomain.containsSameValues(as: expectedADomain))
    }

    func testRevise_reviseArcBLessThanA_correctRevisionReturned() throws {
        let revisedBDomain = try XCTUnwrap(arcBLessThanA.revise(state: variableSet))
        let expectedBDomain = [3, 4]

        XCTAssertTrue(revisedBDomain.containsSameValues(as: expectedBDomain))
    }
}
