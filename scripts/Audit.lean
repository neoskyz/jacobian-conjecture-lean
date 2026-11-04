import Submission

/-! Audit: the refuted statement, the theorem and its axiom closure. -/

-- The statement we refute, exactly as MathDB's frozen target file defines it.
#print Problem.Target
#check @JacobianDisproof.not_target
#print axioms JacobianDisproof.not_target
#check @Submission.solution
#print axioms Submission.solution
-- Universe-polymorphic: instances at several universes.
example : ¬ Problem.Target.{0} := JacobianDisproof.not_target
example : ¬ Problem.Target.{3} := JacobianDisproof.not_target
