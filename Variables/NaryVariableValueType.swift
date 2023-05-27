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
        Array(0..<lhs.value.count).allSatisfy({ idx in
            lhs.value[idx].isEqual(rhs.value[idx])
        })
    }
}

extension NaryVariableValueType: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.forEach({ hasher.combine($0) })
    }
}
