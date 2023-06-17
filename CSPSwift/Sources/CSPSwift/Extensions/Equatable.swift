/**
 Extensions to allow comparision between all `any Equatable`s.
 */
extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return other.inverseIsEqual(self)
        }
        return self == other
    }

    private func inverseIsEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}

