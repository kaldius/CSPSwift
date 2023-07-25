# CSPSwift

A Constraint Satisfaction Problem (CSP) solver package written in Swift. 

## How To Use

## Software Architecture

### CSPSolver

Below is a diagram for the `CSPSolver`. The other components will be explained in later parts.
![PUML diagram for CSPSolver](./diagrams/puml_images/cspSolver.png)

### ConstraintSatisfactionProblem

![PUML diagram for ConstraintSatisfactionProblem](./diagrams/puml_images/csp.png)

The `ConstraintSatisfactionProblem` struct contains all the information about the CSP. It contains a `ConstraintSet` and a `VariableSet` (we will look into both in further detail in later sections).

The most notable features are:

1. `update(using state: VariableSet)`: Given a `VariableSet`, updates the CSP's representation to hold the new information provided. Updates usually happen when `Variable`s are assigned or their domains are changed.

2. `revertToPreviousState()`: `ConstraintSatisfactionProblem` keeps track of a `Stack` of previous `VariableSet`s (basically an undo stack), this method allows us to undo the CSP to its previous state. This is useful for backtracking.

### Constraints

![PUML diagram for Constraints](./diagrams/puml_images/constraints.png)

A `Constraint` is basically used as a predicate. Its methods `isSatisfied` and `isViolated` take in a state in the form of a `VariableSet` and perform the necessary checks.

Only `BinaryConstraints` and `UnaryConstraints` have been implemented since any N-ary constraint can be converted into a combination of _Ternary Constraints_ and some respective auxillary constraints. _Ternary Constraints_ are currently implemented by having a `TernaryVariable` with a `UnaryConstraint` applied to it (see [Hidden Variable Encoding](https://www.cs.cmu.edu/afs/cs/project/jair/pub/volume24/samaras05a-html/node8.html)). (A point of improvement could be to create `TernaryConstraint` which automatically creates the necessary `TernaryVariable` and auxillary constraints.) 

A `ConstraintSet` simply acts as a collection of all constraints in the CSP. The `Set` data structure should be used here, but Swift does not allow heterogenous `Set`s, where all elements conform to the same protocol, so an `Array` is used instead, and the `any` keyword is used to erase the runtime type of the element, so that it can be inserted into the `Array`. This might be a good argument to use classes instead of structs here since `Set`s should be able to hold all objects that inherit from some hypothetical `Constraint` superclass.

### Variables

![PUML diagram for Variables](./diagrams/puml_images/variables.png)

Firstly, `Value` is simply a Protocol for the user to conform to when creating their own value types. 

`Variable` is a Protocol for all type of variables in the CSP, like `IntVariable`, `FloatVariable` etc., and it ensures that all `Variables` provide the necessary getters, setters and queries. Each `Variable` has an associated type `ValueType`, which is the type of the `Value` that the `Variable` stores.

`VariableSet`, like `ConstraintSet` is simply a collection of `Variable`s. For the same reason, an Array is used to hold the `Variable`s. Because the runtime type of each element in the `VariableSet` is erased, some appropriate methods are overloaded to provide a way for the caller to add in the type of the expected `Variable`, so that the return type can already be casted to the correct `ValueType`.

For example,
```
getAssignment("myIntVariable", type: IntVariable.self)
```
returns a value of type `Int` since that is the `ValueType` associated with `IntVariable`.

### Inference

![PUML diagram for InferenceEngines](./diagrams/puml_images/inference.png)