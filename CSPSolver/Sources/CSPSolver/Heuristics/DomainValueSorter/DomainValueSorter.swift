protocol DomainValueSorter {
    func orderDomainValues<V: Variable>(for variable: V) -> [V.ValueType]
}
