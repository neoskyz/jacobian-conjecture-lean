import MathDBUtil
namespace Problem
universe u
noncomputable section
/-- Every polynomial self-map over a characteristic-zero field with constant nonzero
Jacobian determinant has a two-sided polynomial inverse, in every positive dimension. -/
abbrev Target : Prop := ∀ (K : Type u) [Field K] [CharZero K] (n : ℕ), 1 ≤ n →
  ∀ F : Fin n → MvPolynomial (Fin n) K,
    (∃ c : K, c ≠ 0 ∧ Matrix.det (fun i j => MvPolynomial.pderiv j (F i)) = MvPolynomial.C c) →
    ∃ G : Fin n → MvPolynomial (Fin n) K,
      (∀ i, MvPolynomial.bind₁ G (F i) = MvPolynomial.X i) ∧
      (∀ i, MvPolynomial.bind₁ F (G i) = MvPolynomial.X i)
end
end Problem
