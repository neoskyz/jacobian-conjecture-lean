import FtpEvalBench.Sun_Jacobian
import JacobianDisproof

/-!
# MathDB entry point for problem #315779 (JSP-000037)

The frozen target `Problem.Target` (`FtpEvalBench.Sun_Jacobian`, every dimension `n ≥ 1`) is
false, so the entry point is a refutation: `Submission.solution : ¬ Problem.Target`. It does not
settle the plane case `n = 2`. The counterexample is due to L. Alpöge (announced July 19, 2026);
this is an independent formalization.
-/

set_option autoImplicit false

universe u

namespace Submission

/-- MathDB's frozen JSP-000037 target is false, in every universe. -/
theorem solution : ¬ Problem.Target.{u} := JacobianDisproof.not_target

end Submission
