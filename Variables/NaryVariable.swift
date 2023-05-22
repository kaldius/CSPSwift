/**
 A variable which represents N variables at once.
 */

protocol NaryVariable: Variable {
    associatedtype ValueType = NaryVariableDomainValue
}

