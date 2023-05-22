/**
 A variable that represents all the `CellVariable`s that have a `FlowToOthersConstraint`.
 This uses Hidden Variable Encoding to convert N-ary constraints to Unary constraints.
 */
class WaterFlowVariable: NaryVariable {
    var name: String
    
    /// Get: Returns all possible assignment scenarios for all variables in
    /// `associatedVariables`.
    var domain: Set<NaryVariableDomainValue> {
        get {
            let permutations = Array<any Value>.possibleAssignments(domains: associatedDomains)
            let naryVariableDomainValues = permutations.map({ NaryVariableDomainValue(value: $0) })
            return Set(naryVariableDomainValues)
        }
        set {
            // FIXME: for each domain received, set the domains for all associatedVariables too
        }
    }
    
    var assignment: NaryVariableDomainValue? {
        get {
            // FIXME: go into all associatedVariables and get out all their assignments. If any unassigned, return nil?????
            return nil
        }
        set {
            // FIXME: set the assignments for all associatedVariables too
        }
    }
    
    var associatedVariables: [any Variable]
    
    /// Returns an array of domains for each variable in `associatedVariables` where
    /// the order of the domains matches the order in `associatedVariables`.
    private var associatedDomains: [[any Value]] {
        associatedVariables.map({ getDomain(for: $0) })
    }
    
    init(name: String, associatedVariables: [any Variable]) {
        self.name = name
        self.associatedVariables = associatedVariables
    }
    
    private func getDomain(for variable: some Variable) -> [any Value] {
        return Array(variable.domain)
    }
}
