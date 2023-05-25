/**
 `Constraints` holds all the constraints for a given CSP.
 */

public struct Constraints {
    private(set) var allConstraints: [any Constraint]
    
    public init(allConstraints: [any Constraint] = []) {
        self.allConstraints = allConstraints
    }
    
    public mutating func add(constraint: any Constraint) {
        allConstraints.append(constraint)
    }
    
    public var allSatisfied: Bool {
        return allConstraints.allSatisfy({ $0.isSatisfied })
    }
}
