/**
 A protocol that all heuristics for **OrderDomainValues** must conform to.
 */
protocol DomainValueSorter {
    func orderDomainValues<V: Variable>(for variable: V,
                                        state: VariableSet,
                                        constraintSet: ConstraintSet) throws -> [V.ValueType]
}
