/**
 Takes the place of `Variable.ValueType` in an `NaryVariable`.
 This wrapper exists because `[any Value]` cannot conform to `Value`.
 */
struct NaryVariableValueType {
    var value: [any Value]
    
    init(value: [any Value]) {
        self.value = value
    }

    subscript(_ idx: Int) -> (any Value) {
        value[idx]
    }
}

extension NaryVariableValueType: Value {}

extension NaryVariableValueType: Equatable {
    static func == (lhs: NaryVariableValueType, rhs: NaryVariableValueType) -> Bool {
        lhs.value.isEqual(rhs.value)
    }
}

extension NaryVariableValueType: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.forEach({ hasher.combine($0) })
    }
}

extension NaryVariableValueType: Copyable {
    func copy() -> NaryVariableValueType {
        type(of: self).init(value: value.copy())
    }
}
