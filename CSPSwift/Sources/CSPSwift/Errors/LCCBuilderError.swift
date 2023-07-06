enum LCCBuilderError: Error, Equatable {
    case emptyBuilderError
    case oneVariableError
    case twoVariableError
    case noScaleFactorError
    case unmatchedVariablesAndScaleFactorsError(variableCount: Int, scaleFactorCount: Int)
}

extension LCCBuilderError: CustomStringConvertible {
    var description: String {
        switch self {
        case .emptyBuilderError:
            return "LCCBuilder cannot give a result if it is empty"
        case .oneVariableError:
            return "LCCBuilder should not be used for one variable, use a UnaryConstraint instead"
        case .twoVariableError:
            return "LCCBuilder should not be used for two variables, use a BinaryConstraint instead"
        case .noScaleFactorError:
            return "Found nil when accessing scale factor, every variable should have a scale factor"
        case .unmatchedVariablesAndScaleFactorsError(let variableCount, let scaleFactorCount):
            return "Constructor received unequal number of variables(\(variableCount)) and scale factors(\(scaleFactorCount))"
        }
    }
}
