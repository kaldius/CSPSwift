/**
 Takes the place of `Variable.ValueType` in an `NaryVariable`.
 This wrapper exists because `[any Value]` cannot conform to `Value`.
 */
public struct NaryVariableValueType {
    var value: [any Value]
    
    init(value: [any Value]) {
        self.value = value
    }

    subscript(_ idx: Int) -> (any Value) {
        value[idx]
    }
}

extension NaryVariableValueType: Value {
    public static func < (lhs: NaryVariableValueType, rhs: NaryVariableValueType) -> Bool {
        var lhsValue = lhs.value
        var rhsValue = rhs.value
        guard lhsValue.count == rhsValue.count,
              !lhsValue.isEmpty,
              !rhsValue.isEmpty else {
            return false
        }
        if lhsValue.isEqual(rhsValue) {
            lhsValue.removeFirst()
            rhsValue.removeFirst()
            return NaryVariableValueType(value: lhsValue) < NaryVariableValueType(value: rhsValue)
        } else {
            return lhsValue[0].isLessThan(rhsValue[0])
        }
    }
}

extension NaryVariableValueType: CustomDebugStringConvertible {
    public var debugDescription: String {
        value.debugDescription
    }
}

extension NaryVariableValueType: Equatable {
    public static func == (lhs: NaryVariableValueType, rhs: NaryVariableValueType) -> Bool {
        lhs.value.isEqual(rhs.value)
    }
}

extension NaryVariableValueType: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.forEach({ hasher.combine($0) })
    }
}

extension NaryVariableValueType: Copyable {
    public func copy() -> NaryVariableValueType {
        type(of: self).init(value: value.copy())
    }
}
