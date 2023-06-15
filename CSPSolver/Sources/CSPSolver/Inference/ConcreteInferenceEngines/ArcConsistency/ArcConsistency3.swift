/**
 An `InferenceEngine` that uses the **AC-3** algorithm.
 */
public struct ArcConsistency3: InferenceEngine {
    public func makeNewInference(from state: VariableSet, constraintSet: ConstraintSet) throws -> VariableSet? {
        var copiedState = state
        var arcs = Queue<Arc>(given: constraintSet)

        while !arcs.isEmpty {
            guard let arc = arcs.dequeue() else {
                assert(false)
            }
            if let newVariableIDomain = try arc.revise(state: copiedState) {
                if newVariableIDomain.isEmpty {
                    // impossible to carry on 
                    return nil
                }
                try copiedState.setDomain(for: arc.variableIName, to: newVariableIDomain)
                let newArcs = arcsFromNeighbours(of: arc.variableIName,
                                                 except: arc.variableJName,
                                                 using: constraintSet)
                arcs.enqueueAll(in: newArcs)
            }
        }
        return copiedState
    }

    /// Loops through all `BinaryConstraints` in `constraintSet` and creates an `Arc`
    /// from every other `Variable` to `variableName`, except `excludedVarName`.
    private func arcsFromNeighbours(of variableName: String,
                                    except excludedVarName: String,
                                    using constraintSet: ConstraintSet) -> [Arc] {
        var arcs = [Arc]()
        for constraint in constraintSet.allConstraints {
            guard let binConstraint = constraint as? any BinaryConstraint,
                  binConstraint.depends(on: variableName),
                  !binConstraint.depends(on: excludedVarName) else {
                continue
            }
            guard let otherVarName = binConstraint.variableName(otherThan: variableName),
                  let newArc = Arc(from: binConstraint, variableIName: otherVarName) else {
                continue
            }
            arcs.append(newArc)
        }
        return arcs
    }
}
