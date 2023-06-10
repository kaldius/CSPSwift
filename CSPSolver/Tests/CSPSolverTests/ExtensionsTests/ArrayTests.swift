import XCTest
@testable import CSPSolver

final class ArrayTests: XCTestCase {
    func testPossibleAssignments_emptyDomains_returnsEmptyArrayOfArray() {
        let allDomains = [[Int]]()
        XCTAssertEqual(Array<Int>.possibleAssignments(domains: allDomains), [[Int]]())
    }

    func testPossibleAssignments_onlyOneOutcome_returnsCorrectOutcome() {
        let domainA = [1]
        let domainB = [2]
        let domainC = [3]
        let domainD = [4]
        let domainE = [5]

        let allDomains: [[Int]] = [domainA, domainB, domainC, domainD, domainE]

        let expectedPossibleAssignments = [[1, 2, 3, 4, 5]]
        let actualPossibleAssignments = Array<Int>.possibleAssignments(domains: allDomains)

        XCTAssertEqual(actualPossibleAssignments, expectedPossibleAssignments)
    }

    func testPossibleAssignments_fourOutcomes_returnsAllOutcomes() {
        let domainA = [1]
        let domainB = [2, 22]
        let domainC = ["c"]
        let domainD = [4]
        let domainE = [5, 55]

        let allDomains: [[any Value]] = [domainA, domainB, domainC, domainD, domainE]

        let expectedPossibleAssignments: [[any Value]] = [[1, 2, "c", 4, 5],
                                                          [1, 22, "c", 4, 5],
                                                          [1, 2, "c", 4, 55],
                                                          [1, 22, "c", 4, 55]]
        let actualPossibleAssignments = Array<any Value>.possibleAssignments(domains: allDomains)

        XCTAssertTrue(actualPossibleAssignments.containsSameValues(as: (expectedPossibleAssignments)))
    }

    func testPossibleAssignments_stressTest() {
        let numDomains = 5
        let domainSize = 10
        var allDomains = [[Int]]()

        for idx in 0 ..< numDomains {
            let start = idx * domainSize
            allDomains.append(Array(start ..< start + domainSize))
        }

        measure {
            _ = Array<Int>.possibleAssignments(domains: allDomains)
        }
    }

    func testPermutations_emptyArray_returnsArrayOfEmptyArray() {
        let emptyArray = [Int]()
        let result = emptyArray.permutations()
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result[0].isEmpty)
    }

    func testPermutations_singleElement_returnsArrayOfArrayOfSingleElement() {
        let array = [1]
        let result = array.permutations()
        XCTAssertEqual(result, [[1]])
    }

    func testPermutations_multipleElements_returnsCorrectPermutations() {
        let array = [1, 2, 3]
        let expectedResult = [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
        let actualResult = array.permutations()
        XCTAssertEqual(Set(actualResult), Set(expectedResult))
    }

    // 0.0231
    func testPermutations_stressTest() {
        let array = Array(0 ... 7)
        measure {
            _ = array.permutations()
        }
    }

    func testLessThan_differentLengthArrays_returnsFalse() {
        let arrayA = [1, 2, 3]
        let arrayB = [4, 5]

        XCTAssertFalse(arrayA < arrayB)
        XCTAssertFalse(arrayB < arrayA)
    }

    func testLessThan_sameLengthArrays_notAllLess_returnsFalse() {
        let arrayA = [1, 2, 3]
        let arrayB = [4, 5, 3]

        XCTAssertFalse(arrayA < arrayB)
        XCTAssertFalse(arrayB < arrayA)
    }

    func testLessThan_sameLengthArrays_allLess_returnsALessThanB() {
        let arrayA = [1, 2, 3]
        let arrayB = [4, 4, 4]

        XCTAssertTrue(arrayA < arrayB)
        XCTAssertFalse(arrayB < arrayA)
    }
}
