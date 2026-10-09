# JSP-000759 — Lean 4 formalization

A machine-checked Lean 4 formalization of the negative resolution to the Bollobás–Erdős conjecture in Erdős Problem #915:

> *What edge count forces many internally disjoint paths between two vertices?*

Catalog entry JSP-000759 (graph theory / extremal paths). Bollobás and Erdős (1962, [BoEr62]) conjectured that every finite simple graph on $1 + n(m - 1)$ vertices with $1 + n \binom{m}{2}$ edges must contain two vertices joined by $m$ internally vertex-disjoint paths.

Bo Sørensen and Carsten Thomassen disproved this conjecture in 1974 ([SoTh74]):

- **Reference**: B. Sørensen and C. Thomassen, *On $k$-rails in graphs*, J. Combinatorial Theory Ser. B 17 (1974), 143–159. [doi:10.1016/0095-8956(74)90082-3](https://doi.org/10.1016/0095-8956(74)90082-3).

The counterexample is an explicit 17-vertex, 41-edge graph ($m=5, n=4$) containing no pair of vertices joined by 5 internally vertex-disjoint paths.

This repository contains the complete, standalone, machine-checked Lean 4 formalization of the Sørensen–Thomassen disproof.

## Statement of record — `Challenge.lean`

`Challenge.lean` declares the definitions the problem is phrased with and the proposition `jsp000759Statement`. It proves nothing, so a reviewer has only to read that one file to judge *what* has been claimed.

```lean
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.Paths
import Mathlib.Data.Fintype.Card

namespace JSP000759

variable {V : Type*} {G : SimpleGraph V} {u v : V}

/-- The vertices of a path other than its two endpoints. -/
def internalVertices (p : G.Path u v) : Set V :=
  {x | x ∈ (p : G.Walk u v).support ∧ x ≠ u ∧ x ≠ v}

/-- Some two distinct vertices are joined by `m` distinct paths whose interiors are
pairwise disjoint. -/
def HasMInternallyVertexDisjointPaths (G : SimpleGraph V) (m : ℕ) : Prop :=
  ∃ u v : V, u ≠ v ∧ ∃ paths : Fin m → G.Path u v,
    Function.Injective paths ∧
      Set.PairwiseDisjoint Set.univ (fun i ↦ internalVertices (paths i))

/--
Statement of record for JSP-000759 (Erdős Problem #915 / Bollobás–Erdős Conjecture Disproof):
Disproves the conjecture that every finite graph on `1 + n * (m - 1)` vertices
with `1 + n * Nat.choose m 2` edges must contain two vertices joined by `m` internally
vertex-disjoint paths.
-/
def jsp000759Statement : Prop :=
  ¬ (∀ (m n : ℕ), 2 ≤ m → 1 ≤ n →
    ∀ (V : Type) [Fintype V] (G : SimpleGraph V),
      Fintype.card V = 1 + n * (m - 1) →
        G.edgeSet.ncard = 1 + n * Nat.choose m 2 →
          HasMInternallyVertexDisjointPaths G m)

end JSP000759
```

## Proof — `Submission.lean`

`Submission.lean` imports `Challenge.lean`, so the proof and the statement refer to the *same* `jsp000759Statement` constant and cannot drift apart. The top-level result is

```lean
theorem jsp_000759_solved : jsp000759Statement
```

The underlying mathematical architecture consists of:
1. **Explicit Counterexample Construction** (`ErdosProblems/Erdos915.lean`): Constructs the 17-vertex graph with 41 edges.
2. **Degree and Path Separation Analysis**: Proves that every vertex pair fails to possess 5 internally disjoint paths, via case analysis on low-degree outer vertices and triangle structure.
3. **Disproof Theorem** (`Erdos915.not_erdos_915`): Refutes the general assertion for $m=5, n=4$.
4. **Statement Bridge** (`Submission.lean`): Connects `Erdos915.not_erdos_915` to `JSP000759.jsp000759Statement`.

## Mechanical audit

Run `python3 check.py` locally to verify the repository:

```bash
$ python3 check.py
build OK
axioms OK: Classical.choice, Quot.sound, propext
bridge OK: example : jsp000759Statement := jsp_000759_solved
```

The audit checks:
1. `lake build` exits cleanly.
2. `Submission.lean` contains no `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, `partial`, or `native_decide`.
3. The type-checked bridge `example : jsp000759Statement := jsp_000759_solved` succeeds without errors.
4. `#print axioms jsp_000759_solved` depends only on standard foundational axioms:
   - `propext`
   - `Classical.choice`
   - `Quot.sound`

## Attribution and provenance

- **Mathematical solution**: Bo Sørensen and Carsten Thomassen (1974, [SoTh74]).
- **Lean formalization**: OpenAI Codex / GPT-5.6 Sol (initial formalization from `plby/lean-proofs`), packaged, verified, bridged and maintained by Qin Zhao ([Drag0ndddd1118](https://github.com/Drag0ndddd1118)) in standalone verified configuration for The Justin Sun Prize.
