import XCTest
@testable import CSPSolver

final class SortableValueTests: XCTestCase {
    func testSortInt_allPossiblePermutations_returnsCorrectlySorted() {
        let sortableA = SortableValue(value: "A", priority: 1)
        let sortableB = SortableValue(value: "B", priority: 2)
        let sortableC = SortableValue(value: "C", priority: 3)
        let sortableD = SortableValue(value: "D", priority: 4)

        let sortables = [sortableA, sortableB, sortableC, sortableD]
        let allPermutations = sortables.permutations()

        let allPermutationsSorted = allPermutations.map({ $0.sorted() })

        let exptectedSortedArr = [sortableA, sortableB, sortableC, sortableD]

        allPermutationsSorted.forEach({ sortedPermutation in
            XCTAssertEqual(sortedPermutation, exptectedSortedArr)
        })
    }
}
