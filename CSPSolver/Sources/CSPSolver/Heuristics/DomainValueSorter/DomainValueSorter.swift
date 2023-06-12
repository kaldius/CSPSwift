protocol DomainValueSorter {
    func orderDomainValues<V: Variable>(for variable: V,
                                        state: VariableSet,
                                        constraintSet: ConstraintSet) -> [V.ValueType]
}
