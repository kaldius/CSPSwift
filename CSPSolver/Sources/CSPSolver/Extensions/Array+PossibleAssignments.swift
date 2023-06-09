extension Array {
    /// Given an array of domains, where each domain is an array of values,
    /// returns an array of possible assignments.
    /// `e.g. domains = [[1, 2], [3, 4]]`
    /// `output = [[1, 3], [1, 4], [2, 3], [2, 4]]`
    static func possibleAssignments<T>(domains: [[T]]) -> [[T]] {
        if domains.count == 1 {
            return domains[0].map({ [$0] })
        }
        var subproblem = domains
        let lastDomain: [T] = subproblem.removeLast()
        let subproblemSolution: [[T]] = possibleAssignments(domains: subproblem)
        let output: [[T]] = lastDomain.flatMap({ domainValue in
            subproblemSolution.map({ $0 + [domainValue] })
        })
        return output
    }

    // TODO: TEST
    static func permutations<T>(_ array: [T]) -> [[T]] {
        if array.count <= 1 {
            return [array]
        }
        var copy = array
        let last = copy.removeLast()
        let subproblemSolution = permutations(copy)
        var output = [[T]]()
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
