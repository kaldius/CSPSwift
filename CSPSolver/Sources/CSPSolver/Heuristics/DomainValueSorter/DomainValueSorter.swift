/**
 A protocol that all heuristics for **OrderDomainValues** must conform to.
 */
// TODO: compare random domain value selector. might be faster since no inferences!
protocol DomainValueSorter {
    func orderDomainValues<V: Variable>(for variable: V,
                                        state: VariableSet,
                                        constraintSet: ConstraintSet) -> [V.ValueType]
}
