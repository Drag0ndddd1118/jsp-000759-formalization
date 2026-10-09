/-
  The Justin Sun Prize (孙宇晨奖) — JSP-000759
  Challenge.lean: Official Mathematical Problem Statement Contract

  Erdős Problem #915 / Bollobás–Erdős Conjecture:
  "What edge count forces many internally disjoint paths between two vertices?"
-/

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
