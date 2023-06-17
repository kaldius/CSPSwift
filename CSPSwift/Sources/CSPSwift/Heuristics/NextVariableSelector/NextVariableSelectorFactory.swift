/**
 A factory that creates `NextVariableSelector`s.
 */
struct NextVariableSelectorFactory {
    static func create(_ type: NextVariableSelectorType) -> any NextVariableSelector {
        switch type {
        case .minimumRemainingValues:
            return MinimumRemainingValues()
        }
    }
}
