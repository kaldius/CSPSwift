/**
 Sorts domain values randomly.
 */
struct RandomDVS: DomainValueSorter {
    func orderDomainValues<V: Variable>(for variable: V,
                                        state: VariableSet,
                                        constraintSet: ConstraintSet) -> [V.ValueType] {
        let domain = variable.domainAsArray
        let assignableDomainValues = domain.filter({ state.canAssign(variable.name, to: $0) })
        return assignableDomainValues.shuffled()
    }
}
