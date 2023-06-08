
public struct ArcConsistency3: InferenceEngine {
    public var constraintSet: ConstraintSet

    public func makeNewInference(from state: SetOfVariables) -> SetOfVariables? {
        var copiedState = state
        var arcs = Queue<Arc>(given: constraintSet)

        while !arcs.isEmpty {
            guard let arc = arcs.dequeue() else {
                assert(false)
            }
            if let newVariableIDomain = arc.revise(state: copiedState) {
                if newVariableIDomain.isEmpty {
                    // impossible to carry on 
                    return nil
                }
                copiedState.setDomain(for: arc.variableIName, to: newVariableIDomain)
                let newArcs = arcsFromNeighbours(of: arc.variableIName, except: arc.variableJName)
                arcs.enqueueAll(in: newArcs)
            }
        }
        return copiedState
    }

    // TODO: check that it returns reverse arcs
    private func arcsFromNeighbours(of variableName: String, except excludedVarName: String) -> [Arc] {
        var arcs = [Arc]()
        for constraint in constraintSet.allConstraints {
            guard let binConstraint = constraint as? any BinaryConstraint,
                  binConstraint.depends(on: variableName),
                  !binConstraint.depends(on: excludedVarName) else {
                continue
            }
            let otherVarName = binConstraint.variableName(otherThan: variableName)
            guard let newArc = Arc(from: binConstraint, variableIName: otherVarName) else {
                continue
            }
            arcs.append(newArc)
        }
        return arcs
    }
}
