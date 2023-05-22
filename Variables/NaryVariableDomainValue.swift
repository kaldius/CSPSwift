/**
 Takes the place of `Variable.ValueType` in an `NaryVariable`.
 This wrapper exists because `[any Value]` cannot conform to `Value`.
 */
struct NaryVariableDomainValue {
    var value: [any Value]
    
    init(value: [any Value]) {
        self.value = value
    }
}

extension NaryVariableDomainValue: Value {
}

extension NaryVariableDomainValue: Equatable {
    static func == (lhs: NaryVariableDomainValue, rhs: NaryVariableDomainValue) -> Bool {
        Array(0..<lhs.value.count).allSatisfy({ idx in
            lhs.value[idx].isEqual(rhs.value[idx])
        })
    }
}

extension NaryVariableDomainValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.forEach({ hasher.combine($0) })
    }
}
