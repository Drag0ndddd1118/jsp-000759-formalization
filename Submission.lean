/-
  The Justin Sun Prize (孙宇晨奖) — JSP-000759
  Submission.lean: Top-Level Resolution Theorem & Bridge

  This file bridges the underlying constructive Lean 4 formalization of Erdős
  Problem #915 (Sørensen & Thomassen 1974) to the challenge contract in `Challenge.lean`.
-/

import Challenge
import ErdosProblems.Erdos915

open JSP000759

/--
Top-level resolution theorem for JSP-000759 (Erdős Problem #915).
Proves `jsp000759Statement` by bridging from Sørensen–Thomassen's counterexample theorem.
-/
theorem jsp_000759_solved : jsp000759Statement := by
  intro hclaim
  refine Erdos915.not_erdos_915 fun m n hm hn V instV G hcard hedges => ?_
  obtain ⟨u, v, huv, paths, hinj, hdisj⟩ := hclaim m n hm hn V G hcard hedges
  exact ⟨u, v, huv, paths, hinj, hdisj⟩

#print axioms jsp_000759_solved
