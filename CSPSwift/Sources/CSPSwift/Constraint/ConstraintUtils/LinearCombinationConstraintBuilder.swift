
// TODO: make this take in "AddableVariable"s instead of just IntVariables
public struct LinearCombinationConstraintBuilder {
    private var variables: [IntVariable]
    private var variableNameToScaleFactor: [String: Int]
    public var additionalConstant: Int

    public init() {
        self.variables = []
        self.variableNameToScaleFactor = [:]
        self.additionalConstant = 0
    }

    public mutating func add(_ variable: IntVariable, scaleFactor: Int = 1) {
        variables.append(variable)
        variableNameToScaleFactor[variable.name] = scaleFactor
    }

    public var result: (variables: [any Variable], constraints: [LinearCombinationConstraint]) {
        get throws {
            try checkConditions()
            if variables.count == 3 {
                return try resultBaseCase
            }
            var subLLCBuilder = Self.init()
            subLLCBuilder.additionalConstant = additionalConstant
            var newVariables: [any Variable] = []
            var constraints : [LinearCombinationConstraint] = []

            // merge first two variables into a representative variable
            let (rep, ternaryVar, constraint) = try createVariablesAndLCCs(from: variables[0], and: variables[1])
            subLLCBuilder.add(rep)
            newVariables.append(rep)
            newVariables.append(ternaryVar)
            constraints.append(constraint)

            // add all remaining variables into subLLCBuilder
            for idx in 2 ..< variables.count {
                subLLCBuilder.add(variables[idx], scaleFactor: variableNameToScaleFactor[variables[idx].name]!)
            }

            // solve the subproblem and append to result
            let subproblemSolution = try subLLCBuilder.result
            newVariables += subproblemSolution.variables
            constraints += subproblemSolution.constraints
            return (newVariables, constraints)
        }
    }

    private var resultBaseCase: (variables: [TernaryVariable], constraints: [LinearCombinationConstraint]) {
        get throws {
            guard let scaleFactorA = variableNameToScaleFactor[variables[0].name],
                  let scaleFactorB = variableNameToScaleFactor[variables[1].name],
                  let scaleFactorC = variableNameToScaleFactor[variables[2].name] else {
                throw LCCBuilderError.noScaleFactorError
            }
            let (ternaryVariable, constraint) = createTernaryVariableAndLCC(variableA: variables[0],
                                                                            scaleFactorA: scaleFactorA,
                                                                            variableB: variables[1],
                                                                            scaleFactorB: scaleFactorB,
                                                                            variableC: variables[2],
                                                                            scaleFactorC: scaleFactorC,
                                                                            add: additionalConstant)
            return ([ternaryVariable], [constraint])
        }
    }

    private func createTernaryVariableAndLCC(variableA: IntVariable,
                                             scaleFactorA: Int,
                                             variableB: IntVariable,
                                             scaleFactorB: Int,
                                             variableC: IntVariable,
                                             scaleFactorC: Int,
                                             add: Int = 0) -> (ternaryVariable: TernaryVariable,
                                                                           constraint: LinearCombinationConstraint) {
        let name = variableA.name + "+" + variableB.name + "+" + variableC.name
        let ternaryVariable = TernaryVariable(name: name,
                                              variableA: variableA,
                                              variableB: variableB,
                                              variableC: variableC)
        let constraint = LinearCombinationConstraint(ternaryVariable,
                                                     scaleA: Float(scaleFactorA),
                                                     scaleB: Float(scaleFactorB),
                                                     scaleC: Float(scaleFactorC),
                                                     add: Float(add))
        return (ternaryVariable, constraint)
    }

    private func createVariablesAndLCCs(from variableA: IntVariable,
                                        and variableB: IntVariable) throws -> (representativeVariable: IntVariable,
                                                                               ternaryVariable: TernaryVariable,
                                                                               constraint: LinearCombinationConstraint) {
        guard let scaleFactorA = variableNameToScaleFactor[variableA.name],
              let scaleFactorB = variableNameToScaleFactor[variableB.name] else {
            throw LCCBuilderError.noScaleFactorError
        }
        let name = variableA.name + "+" + variableB.name
        let possibleAssignments = Array<Int>
            .possibleAssignments(domains: [variableA.domainAsArray, variableB.domainAsArray])
        let variableCDomain = possibleAssignments.map({ pair in
            pair[0] * scaleFactorA + pair[1] * scaleFactorB
        })
        let variableC = IntVariable(name: "(" + name + "_rep)", domain: Set(variableCDomain))
        let (ternaryVariable, constraint) = createTernaryVariableAndLCC(variableA: variableA,
                                                                        scaleFactorA: scaleFactorA,
                                                                        variableB: variableB,
                                                                        scaleFactorB: scaleFactorB,
                                                                        variableC: variableC,
                                                                        scaleFactorC: -1)
        return (variableC, ternaryVariable, constraint)
    }

    private func checkConditions() throws {
        switch variables.count {
        case 0:
            throw LCCBuilderError.emptyBuilderError
        case 1:
            throw LCCBuilderError.oneVariableError
        case 2:
            throw LCCBuilderError.twoVariableError
        default:
            break
        }
    }
}
