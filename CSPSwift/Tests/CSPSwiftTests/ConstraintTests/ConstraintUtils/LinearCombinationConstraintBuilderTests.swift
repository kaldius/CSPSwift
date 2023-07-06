import XCTest
@testable import CSPSwift

final class LLCBuilderTests: XCTestCase {
    func testInit() throws {
        let intVariableA = IntVariable(name: "a", domain: Set([0, 1]))
        let intVariableB = IntVariable(name: "b", domain: Set([1, 2, 3]))
        let intVariableC = IntVariable(name: "c", domain: Set([2, 3]))

        let builderA = try LinearCombinationConstraintBuilder(variables: [intVariableA, intVariableB, intVariableC],
                                                              scaleFactors: [1, 2, 3],
                                                              additionalConstant: -6)

        var builderB = LinearCombinationConstraintBuilder()
        builderB.add(intVariableA)
        builderB.add(intVariableB, scaleFactor: 2)
        builderB.add(intVariableC, scaleFactor: 3)
        builderB.additionalConstant = -6

        XCTAssertEqual(builderA, builderB)
    }

    func testResult_zeroVariables_throwsError() {
        let builder = LinearCombinationConstraintBuilder()

        XCTAssertThrowsError(try builder.result,
                             "Should throw emptyBuilderError",
                             { XCTAssertEqual($0 as? LCCBuilderError, LCCBuilderError.emptyBuilderError) })
    }

    func testResult_oneVariable_throwsError() {
        let intVariableA = IntVariable(name: "a", domain: Set([0, 1]))
        var builder = LinearCombinationConstraintBuilder()
        builder.add(intVariableA, scaleFactor: 4)

        XCTAssertThrowsError(try builder.result,
                             "Should throw oneVariableError",
                             { XCTAssertEqual($0 as? LCCBuilderError, LCCBuilderError.oneVariableError) })
    }

    func testResult_twoVariables_throwsError() {
        let intVariableA = IntVariable(name: "a", domain: Set([0, 1]))
        let intVariableB = IntVariable(name: "b", domain: Set([1, 2, 3]))
        var builder = LinearCombinationConstraintBuilder()
        builder.add(intVariableA, scaleFactor: 4)
        builder.add(intVariableB, scaleFactor: 3)

        XCTAssertThrowsError(try builder.result,
                             "Should throw twoVariableError",
                             { XCTAssertEqual($0 as? LCCBuilderError, LCCBuilderError.twoVariableError) })
    }

    // Test case:
    // a + 2b + 3c = 6
    func testResult_threeVariables() throws {
        let intVariableA = IntVariable(name: "a", domain: Set([0, 1]))
        let intVariableB = IntVariable(name: "b", domain: Set([1, 2, 3]))
        let intVariableC = IntVariable(name: "c", domain: Set([2, 3]))

        let builder = try LinearCombinationConstraintBuilder(variables: [intVariableA, intVariableB, intVariableC],
                                                             scaleFactors: [1, 2, 3],
                                                             additionalConstant: -6)

        let ternaryVariableABC = TernaryVariable(name: "a+b+c",
                                                 variableA: intVariableA,
                                                 variableB: intVariableB,
                                                 variableC: intVariableC)
        let lccABC = LinearCombinationConstraint(ternaryVariableABC,
                                                 scaleA: 1,
                                                 scaleB: 2,
                                                 scaleC: 3,
                                                 add: -6)

        let expectedVariables: [any Variable] = [ternaryVariableABC]
        let expectedConstraints: [any Constraint] = [lccABC] + ternaryVariableABC.auxillaryConstraints

        let actualResult = try builder.result

        XCTAssertTrue(expectedVariables.containsSameValues(as: actualResult.variables))
        XCTAssertTrue(expectedConstraints.containsSameValues(as: actualResult.constraints))
    }

    // Test case:
    // a + 2b + 3c - 4d - e = -13
    func testResult_fiveVariables() throws {
        let intVariableA = IntVariable(name: "a", domain: Set([0, 1]))
        let intVariableB = IntVariable(name: "b", domain: Set([1, 2, 3]))
        let intVariableC = IntVariable(name: "c", domain: Set([2, 3]))
        let intVariableD = IntVariable(name: "d", domain: Set([3, 4, 5]))
        let intVariableE = IntVariable(name: "e", domain: Set([4, 5]))

        let builder = try LinearCombinationConstraintBuilder(variables: [intVariableA,
                                                                         intVariableB,
                                                                         intVariableC,
                                                                         intVariableD,
                                                                         intVariableE],
                                                             scaleFactors: [1, 2, 3, -4, -1],
                                                             additionalConstant: 13)

        let repAB = IntVariable(name: "(a+b_rep)", domain: Set(2 ... 7))
        let ternaryVariableAB = TernaryVariable(name: "a+b+(a+b_rep)",
                                                variableA: intVariableA,
                                                variableB: intVariableB,
                                                variableC: repAB)
        let lccAB = LinearCombinationConstraint(ternaryVariableAB,
                                                scaleA: 1,
                                                scaleB: 2,
                                                scaleC: -1)

        let repAbC = IntVariable(name: "((a+b_rep)+c_rep)", domain: Set(8 ... 16))
        let ternaryVariableAbC = TernaryVariable(name: "(a+b_rep)+c+((a+b_rep)+c_rep)",
                                                variableA: repAB,
                                                variableB: intVariableC,
                                                variableC: repAbC)
        let lccAbC = LinearCombinationConstraint(ternaryVariableAbC,
                                                 scaleA: 1,
                                                 scaleB: 3,
                                                 scaleC: -1)

        let ternaryVariableAbcDE = TernaryVariable(name: "((a+b_rep)+c_rep)+d+e",
                                                   variableA: repAbC,
                                                   variableB: intVariableD,
                                                   variableC: intVariableE)
        let lccAbcDE = LinearCombinationConstraint(ternaryVariableAbcDE,
                                                   scaleA: 1,
                                                   scaleB: -4,
                                                   scaleC: -1,
                                                   add: 13)

        let expectedVariables: [any Variable] = [repAB, repAbC, ternaryVariableAB,
                                                 ternaryVariableAbC, ternaryVariableAbcDE]
        let expectedConstraints: [any Constraint] = [lccAB, lccAbC, lccAbcDE]
        + [ternaryVariableAB,
           ternaryVariableAbC,
           ternaryVariableAbcDE].flatMap({ $0.auxillaryConstraints })

        let actualResult = try builder.result

        XCTAssertTrue(expectedVariables.containsSameValues(as: actualResult.variables))
        XCTAssertTrue(expectedConstraints.containsSameValues(as: actualResult.constraints))
    }

    // Test case:
    // a + 2b + c - 2d - e + 3f - g = 4
    func testResult_sevenVariables() throws {
        let intVariableA = IntVariable(name: "a", domain: Set([0, 1]))
        let intVariableB = IntVariable(name: "b", domain: Set([1, 2, 3]))
        let intVariableC = IntVariable(name: "c", domain: Set([2, 3]))
        let intVariableD = IntVariable(name: "d", domain: Set([3, 4, 5]))
        let intVariableE = IntVariable(name: "e", domain: Set([4, 5]))
        let intVariableF = IntVariable(name: "f", domain: Set([5, 6, 7]))
        let intVariableG = IntVariable(name: "g", domain: Set([3, 5, 1]))

        let builder = try LinearCombinationConstraintBuilder(variables: [intVariableA,
                                                                         intVariableB,
                                                                         intVariableC,
                                                                         intVariableD,
                                                                         intVariableE,
                                                                         intVariableF,
                                                                         intVariableG],
                                                             scaleFactors: [1, 2, 1, -2, -1, 3, -1],
                                                             additionalConstant: -4)

        let repAB = IntVariable(name: "(a+b_rep)", domain: Set(2 ... 7))
        let ternaryVariableAB = TernaryVariable(name: "a+b+(a+b_rep)",
                                                variableA: intVariableA,
                                                variableB: intVariableB,
                                                variableC: repAB)
        let lccAB = LinearCombinationConstraint(ternaryVariableAB,
                                                scaleA: 1,
                                                scaleB: 2,
                                                scaleC: -1)

        let repAbC = IntVariable(name: "((a+b_rep)+c_rep)", domain: Set(4 ... 10))
        let ternaryVariableAbC = TernaryVariable(name: "(a+b_rep)+c+((a+b_rep)+c_rep)",
                                                variableA: repAB,
                                                variableB: intVariableC,
                                                variableC: repAbC)
        let lccAbC = LinearCombinationConstraint(ternaryVariableAbC,
                                                 scaleA: 1,
                                                 scaleB: 1,
                                                 scaleC: -1)

        let repAbcD = IntVariable(name: "(((a+b_rep)+c_rep)+d_rep)", domain: Set(-6 ... 4))
        let ternaryVariableAbcD = TernaryVariable(name: "((a+b_rep)+c_rep)+d+(((a+b_rep)+c_rep)+d_rep)",
                                                  variableA: repAbC,
                                                  variableB: intVariableD,
                                                  variableC: repAbcD)
        let lccAbcD = LinearCombinationConstraint(ternaryVariableAbcD,
                                                  scaleA: 1,
                                                  scaleB: -2,
                                                  scaleC: -1)

        let repAbcdE = IntVariable(name: "((((a+b_rep)+c_rep)+d_rep)+e_rep)", domain: Set(-11 ... 0))
        let ternaryVariableAbcdE = TernaryVariable(name: "(((a+b_rep)+c_rep)+d_rep)+e+((((a+b_rep)+c_rep)+d_rep)+e_rep)",
                                                   variableA: repAbcD,
                                                   variableB: intVariableE,
                                                   variableC: repAbcdE)
        let lccAbcdE = LinearCombinationConstraint(ternaryVariableAbcdE,
                                                  scaleA: 1,
                                                  scaleB: -1,
                                                  scaleC: -1)

        let ternaryVariableAbcdeFG = TernaryVariable(name: "((((a+b_rep)+c_rep)+d_rep)+e_rep)+f+g",
                                                     variableA: repAbcdE,
                                                     variableB: intVariableF,
                                                     variableC: intVariableG)
        let lccAbcdeFG = LinearCombinationConstraint(ternaryVariableAbcdeFG,
                                                     scaleA: 1,
                                                     scaleB: 3,
                                                     scaleC: -1,
                                                     add: -4)

        let expectedVariables: [any Variable] = [repAB, repAbC, repAbcD, repAbcdE, ternaryVariableAB,
                                                 ternaryVariableAbC, ternaryVariableAbcD,
                                                 ternaryVariableAbcdE, ternaryVariableAbcdeFG]
        let expectedConstraints: [any Constraint] = [lccAB, lccAbC, lccAbcD, lccAbcdE, lccAbcdeFG]
        + [ternaryVariableAB,
           ternaryVariableAbC,
           ternaryVariableAbcD,
           ternaryVariableAbcdE,
           ternaryVariableAbcdeFG].flatMap({ $0.auxillaryConstraints })

        let actualResult = try builder.result

        XCTAssertTrue(expectedVariables.containsSameValues(as: actualResult.variables))
        XCTAssertTrue(expectedConstraints.containsSameValues(as: actualResult.constraints))
    }
}
