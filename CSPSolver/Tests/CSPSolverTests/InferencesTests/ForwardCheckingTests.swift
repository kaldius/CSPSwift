import XCTest
@testable import CSPSolver

final class ForwardCheckingTests: XCTestCase {
    // Example used here:
    //     T W O
    // +   T W O
    // ----------
    //   F O U R
    // ----------

    var intVariableT: IntVariable!
    var intVariableW: IntVariable!
    var intVariableO: IntVariable!
    var intVariableF: IntVariable!
    var intVariableU: IntVariable!
    var intVariableR: IntVariable!
    var intVariableX: IntVariable!
    var intVariableY: IntVariable!
    var intVariableC1: IntVariable!
    var intVariableC2: IntVariable!

    var dualVariableO_R_C1: TernaryVariable!
    var dualVariableW_C1_X: TernaryVariable!
    var dualVariableU_C2_X: TernaryVariable!
    var dualVariableT_C2_Y: TernaryVariable!
    var dualVariableO_F_Y: TernaryVariable!

    var allIntVariables: [IntVariable]!
    var allDualVariables: [TernaryVariable]!
    var allVariables: [any Variable]!

    var variableSet: SetOfVariables!

    var auxillaryConstraintT: AuxillaryConstraint!
    var auxillaryConstraintW: AuxillaryConstraint!
    var auxillaryConstraintOa: AuxillaryConstraint!
    var auxillaryConstraintOb: AuxillaryConstraint!
    var auxillaryConstraintF: AuxillaryConstraint!
    var auxillaryConstraintU: AuxillaryConstraint!
    var auxillaryConstraintR: AuxillaryConstraint!
    var auxillaryConstraintXa: AuxillaryConstraint!
    var auxillaryConstraintXb: AuxillaryConstraint!
    var auxillaryConstraintYa: AuxillaryConstraint!
    var auxillaryConstraintYb: AuxillaryConstraint!
    var auxillaryConstraintC1a: AuxillaryConstraint!
    var auxillaryConstraintC1b: AuxillaryConstraint!
    var auxillaryConstraintC2a: AuxillaryConstraint!
    var auxillaryConstraintC2b: AuxillaryConstraint!

    var constraintO_R_C1: LinearCombinationConstraint!
    var constraintW_C1_X: LinearCombinationConstraint!
    var constraintU_C2_X: LinearCombinationConstraint!
    var constraintT_C2_Y: LinearCombinationConstraint!
    var constraintO_F_Y: LinearCombinationConstraint!

    var allConstraints: [any Constraint]!

    var inferenceEngines: [InferenceEngine]!

    override func setUp() {
        super.setUp()
        intVariableT = IntVariable(name: "T", domain: Set(1 ... 9))
        intVariableW = IntVariable(name: "W", domain: Set(0 ... 9))
        intVariableO = IntVariable(name: "O", domain: Set(0 ... 9))
        intVariableF = IntVariable(name: "F", domain: Set(1 ... 9))
        intVariableU = IntVariable(name: "U", domain: Set(0 ... 9))
        intVariableR = IntVariable(name: "R", domain: Set(0 ... 9))
        intVariableX = IntVariable(name: "X", domain: Set(0 ... 19))
        intVariableY = IntVariable(name: "Y", domain: Set(10 ... 99))
        intVariableC1 = IntVariable(name: "C1", domain: Set(0 ... 1))
        intVariableC2 = IntVariable(name: "C2", domain: Set(0 ... 1))

        dualVariableO_R_C1 = TernaryVariable(name: "O_R_C1",
                                             variableA: intVariableO,
                                             variableB: intVariableR,
                                             variableC: intVariableC1)
        dualVariableW_C1_X = TernaryVariable(name: "W_C1_X",
                                             variableA: intVariableW,
                                             variableB: intVariableC1,
                                             variableC: intVariableX)
        dualVariableU_C2_X = TernaryVariable(name: "U_C2_X",
                                             variableA: intVariableU,
                                             variableB: intVariableC2,
                                             variableC: intVariableX)
        dualVariableT_C2_Y = TernaryVariable(name: "T_C2_Y",
                                             variableA: intVariableT,
                                             variableB: intVariableC2,
                                             variableC: intVariableY)
        dualVariableO_F_Y = TernaryVariable(name: "O_F_Y",
                                            variableA: intVariableO,
                                            variableB: intVariableF,
                                            variableC: intVariableY)

        allIntVariables = [intVariableT,
                           intVariableW,
                           intVariableO,
                           intVariableF,
                           intVariableU,
                           intVariableR,
                           intVariableX,
                           intVariableY,
                           intVariableC1,
                           intVariableC2]

        allDualVariables = [dualVariableO_R_C1,
                            dualVariableW_C1_X,
                            dualVariableU_C2_X,
                            dualVariableT_C2_Y,
                            dualVariableO_F_Y]

        allVariables = [intVariableT,
                        intVariableW,
                        intVariableO,
                        intVariableF,
                        intVariableU,
                        intVariableR,
                        intVariableX,
                        intVariableY,
                        intVariableC1,
                        intVariableC2,
                        dualVariableO_R_C1,
                        dualVariableW_C1_X,
                        dualVariableU_C2_X,
                        dualVariableT_C2_Y,
                        dualVariableO_F_Y]

        variableSet = SetOfVariables(from: allVariables)

        auxillaryConstraintT = AuxillaryConstraint(mainVariable: intVariableT,
                                                   dualVariable: dualVariableT_C2_Y)
        auxillaryConstraintW = AuxillaryConstraint(mainVariable: intVariableW,
                                                   dualVariable: dualVariableW_C1_X)
        auxillaryConstraintOa = AuxillaryConstraint(mainVariable: intVariableO,
                                                    dualVariable: dualVariableO_F_Y)
        auxillaryConstraintOb = AuxillaryConstraint(mainVariable: intVariableO,
                                                    dualVariable: dualVariableO_R_C1)
        auxillaryConstraintF = AuxillaryConstraint(mainVariable: intVariableF,
                                                   dualVariable: dualVariableO_F_Y)
        auxillaryConstraintU = AuxillaryConstraint(mainVariable: intVariableU,
                                                   dualVariable: dualVariableU_C2_X)
        auxillaryConstraintR = AuxillaryConstraint(mainVariable: intVariableR,
                                                   dualVariable: dualVariableO_R_C1)
        auxillaryConstraintXa = AuxillaryConstraint(mainVariable: intVariableX,
                                                    dualVariable: dualVariableW_C1_X)
        auxillaryConstraintXb = AuxillaryConstraint(mainVariable: intVariableX,
                                                    dualVariable: dualVariableU_C2_X)
        auxillaryConstraintYa = AuxillaryConstraint(mainVariable: intVariableY,
                                                    dualVariable: dualVariableT_C2_Y)
        auxillaryConstraintYb = AuxillaryConstraint(mainVariable: intVariableY,
                                                    dualVariable: dualVariableO_F_Y)
        auxillaryConstraintC1a = AuxillaryConstraint(mainVariable: intVariableC1,
                                                     dualVariable: dualVariableO_R_C1)
        auxillaryConstraintC1b = AuxillaryConstraint(mainVariable: intVariableC1,
                                                     dualVariable: dualVariableW_C1_X)
        auxillaryConstraintC2a = AuxillaryConstraint(mainVariable: intVariableC2,
                                                     dualVariable: dualVariableU_C2_X)
        auxillaryConstraintC2b = AuxillaryConstraint(mainVariable: intVariableC2,
                                                     dualVariable: dualVariableT_C2_Y)

        constraintO_R_C1 = LinearCombinationConstraint(dualVariableO_R_C1,
                                                       scaleA: 2,
                                                       scaleB: -1,
                                                       scaleC: -10)
        constraintW_C1_X = LinearCombinationConstraint(dualVariableW_C1_X,
                                                       scaleA: 2,
                                                       scaleB: 1,
                                                       scaleC: -1)
        constraintU_C2_X = LinearCombinationConstraint(dualVariableU_C2_X,
                                                       scaleA: 1,
                                                       scaleB: 10,
                                                       scaleC: -1)
        constraintT_C2_Y = LinearCombinationConstraint(dualVariableT_C2_Y,
                                                       scaleA: 2,
                                                       scaleB: 1,
                                                       scaleC: -1)
        constraintO_F_Y = LinearCombinationConstraint(dualVariableO_F_Y,
                                                      scaleA: 1,
                                                      scaleB: 10,
                                                      scaleC: -1)

        allConstraints = [auxillaryConstraintT,
                          auxillaryConstraintW,
                          auxillaryConstraintOa,
                          auxillaryConstraintOb,
                          auxillaryConstraintF,
                          auxillaryConstraintU,
                          auxillaryConstraintR,
                          auxillaryConstraintXa,
                          auxillaryConstraintXb,
                          auxillaryConstraintYa,
                          auxillaryConstraintYb,
                          auxillaryConstraintC1a,
                          auxillaryConstraintC1b,
                          auxillaryConstraintC2a,
                          auxillaryConstraintC2b,
                          constraintO_R_C1,
                          constraintW_C1_X,
                          constraintU_C2_X,
                          constraintT_C2_Y,
                          constraintO_F_Y]

        inferenceEngines = createAllEnginePermutations(allConstraints: allConstraints)
    }

    // Since Constraints are in ordered arrays, need to create all possible permutations
    // and ensure that we arrive at the same inferences.
    private func createAllEnginePermutations(allConstraints: [any Constraint]) -> [any InferenceEngine] {
        var inferenceEngines = [any InferenceEngine]()

        let constraintPermutations = [any Constraint].permutations(allConstraints)

        for constraintPerm in constraintPermutations {
            let constraintSet = ConstraintSet(allConstraints: constraintPerm)
            inferenceEngines.append(ForwardChecking(constraintSet: constraintSet))
        }

        return inferenceEngines
    }

    /*
    func testMakeNewInference_settingFTo1() {
        // assign F to 1
        variableSet.assign(intVariableF.name, to: 1)
        let assignmentF = variableSet.getAssignment(intVariableF.name, type: IntVariable.self)
        XCTAssertEqual(assignmentF, 1)

        // assign O to 6
        variableSet.assign(intVariableO.name, to: 6)
        let assignmentO = variableSet.getAssignment(intVariableO.name, type: IntVariable.self)
        XCTAssertEqual(assignmentO, 6)

        for engine in inferenceEngines {
            // make a new inference
            let inference = engine.makeNewInference(from: variableSet)

            // get all domains from inference
            let inferredIntVarDomains = allIntVariables.map({ variable in
                Set(inference.getDomain(variable.name, type: IntVariable.self))
            })
            let inferredDualVarDomains = allDualVariables.map({ variable in
                Set(inference.getDomain(variable.name, type: TernaryVariable.self))
            })

            // define expected domains
            // let expectedDomainT = Set(1 ... 9)
            let expectedDomainT = Set([8])
            // let expectedDomainW = Set(0 ... 9)
            let expectedDomainW = Set(0 ... 4)
            let expectedDomainO = Set([6])
            let expectedDomainF = Set([1])
            // let expectedDomainU = Set(0 ... 9)
            let expectedDomainU = Set(1 ... 9)
            let expectedDomainR = Set([2])
            // let expectedDomainX = Set(0 ... 19)
            let expectedDomainX = Set(1 ... 9)
            let expectedDomainY = Set([16])
            let expectedDomainC1 = Set([1])
            let expectedDomainC2 = Set([0])

            let expectedDomainO_R_C1 = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainO),
                                               Array(expectedDomainR),
                                               Array(expectedDomainC1)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainW_C1_X = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainW),
                                               Array(expectedDomainC1),
                                               Array(expectedDomainX)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainU_C2_X = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainU),
                                               Array(expectedDomainC2),
                                               Array(expectedDomainX)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainT_C2_Y = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainT),
                                               Array(expectedDomainC2),
                                               Array(expectedDomainY)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainO_F_Y = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainO),
                                               Array(expectedDomainF),
                                               Array(expectedDomainY)])
                    .map({ NaryVariableValueType(value: $0) }))

            let expectedIntVarDomains = [expectedDomainT,
                                         expectedDomainW,
                                         expectedDomainO,
                                         expectedDomainF,
                                         expectedDomainU,
                                         expectedDomainR,
                                         expectedDomainX,
                                         expectedDomainY,
                                         expectedDomainC1,
                                         expectedDomainC2]

            let expectedDualVarDomains = [expectedDomainO_R_C1,
                                          expectedDomainW_C1_X,
                                          expectedDomainU_C2_X,
                                          expectedDomainT_C2_Y,
                                          expectedDomainO_F_Y]

            for idx in 0 ..< expectedIntVarDomains.count {
                XCTAssertEqual(inferredIntVarDomains[idx], expectedIntVarDomains[idx], "IntVariable at index: \(idx)")
            }
            for idx in 0 ..< expectedDualVarDomains.count {
                XCTAssertEqual(inferredDualVarDomains[idx], expectedDualVarDomains[idx], "DualVariable at index: \(idx)")
            }
        }
    }
     */
}
