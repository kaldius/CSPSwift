extension Array {
    /// Given an array of domains, where each domain is an array of values,
    /// returns an array of possible assignments.
    /// `e.g. domains = [[1, 2], [3, 4]]`
    /// `output = [[1, 3], [1, 4], [2, 3], [2, 4]]`
    ///
    /// Runtime: `nd^n` (where `n`: number of domains; `d`: max domain size)
    static func possibleAssignments<T>(domains: [[T]]) -> [[T]] {
        guard !domains.isEmpty else {
            return [[T]]()
        }
        var output = domains[0].map({ [$0] })
        for idx in 1 ..< domains.count {
            let domain = domains[idx]
            output = domain.flatMap({ domainValue in
                output.map({ arr in
                    var new = arr
                    new.append(domainValue)
                    return new
                })
            })
        }
        return output
    }

    func permutations() -> [[Element]] {
        if self.count <= 1 {
            return [self]
        }
        var copy = self
        let last = copy.removeLast()
        let subproblemSolution = copy.permutations()
        var output = [[Element]]()
        for perm in subproblemSolution {
            for idx in 0 ... perm.count {
                var copiedPerm = perm
                copiedPerm.insert(last, at: idx)
                output.append(copiedPerm)
            }
        }
        return output
    }
}

extension Array: Comparable where Element: Comparable {
    public static func < (lhs: [Element], rhs: [Element]) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        return (0 ..< lhs.count).allSatisfy({ idx in
            lhs[idx] < rhs[idx]
        })
    }
}
