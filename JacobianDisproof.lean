import FtpEvalBench.Sun_Jacobian

/-!
# The JSP-000037 target (MathDB #315779, `Sun_Jacobian.lean`) is false

`Problem.Target` states that, over every field of characteristic zero and in every positive
dimension, a polynomial self-map with constant nonzero Jacobian determinant has a two-sided
polynomial inverse. We prove `¬ Problem.Target`, in every universe, using the explicit
three-dimensional counterexample announced by L. Alpöge in July 2026:

  F₁ = (1 + z₁z₂)³ z₃ + z₂² (1 + z₁z₂)(4 + 3z₁z₂)
  F₂ = z₂ + 3z₁ (1 + z₁z₂)² z₃ + 3z₁z₂² (4 + 3z₁z₂)
  F₃ = 2z₁ − 3z₁²z₂ − z₁³z₃

Its Jacobian determinant is the constant `-2`, and
`F(0, 0, -1/4) = F(1, -3/2, 13/2) = F(-1, 3/2, 13/2) = (-1/4, 0, 0)`.
A polynomial left inverse `G` (`G ∘ F = id`) would make `F` injective, which it is not.

This is an independent formalization; the mathematics is Alpöge's.
-/

universe u

namespace JacobianDisproof

open MvPolynomial

section General

variable {K : Type*} [Field K]

/-- Alpöge's map `F : K³ → K³`, with coordinates `z₁ = X 0`, `z₂ = X 1`, `z₃ = X 2`. -/
noncomputable def F : Fin 3 → MvPolynomial (Fin 3) K :=
  ![(1 + X 0 * X 1) ^ 3 * X 2 + X 1 ^ 2 * (1 + X 0 * X 1) * (4 + 3 * X 0 * X 1),
    X 1 + 3 * X 0 * (1 + X 0 * X 1) ^ 2 * X 2 + 3 * X 0 * X 1 ^ 2 * (4 + 3 * X 0 * X 1),
    2 * X 0 - 3 * X 0 ^ 2 * X 1 - X 0 ^ 3 * X 2]

/-- A partial derivative of a numeral literal is zero. -/
@[simp] lemma pderiv_numeral (i : Fin 3) (n : ℕ) [n.AtLeastTwo] :
    pderiv i (no_index (OfNat.ofNat n : MvPolynomial (Fin 3) K)) = 0 := by
  exact (pderiv i).map_natCast n

/- The nine entries of the Jacobian matrix `(∂Fᵢ/∂zⱼ)`. -/

lemma d00 : pderiv 0 (F (K := K) 0) =
    3 * X 0 ^ 2 * X 1 ^ 3 * X 2 + 6 * X 0 * X 1 ^ 4 + 6 * X 0 * X 1 ^ 2 * X 2 + 7 * X 1 ^ 3 + 3 * X 1 * X 2 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul, nsmul_eq_mul]
  ring

lemma d01 : pderiv 1 (F (K := K) 0) =
    3 * X 0 ^ 3 * X 1 ^ 2 * X 2 + 12 * X 0 ^ 2 * X 1 ^ 3 + 6 * X 0 ^ 2 * X 1 * X 2 + 21 * X 0 * X 1 ^ 2 + 3 * X 0 * X 2 + 8 * X 1 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul, nsmul_eq_mul]
  ring

lemma d02 : pderiv 2 (F (K := K) 0) =
    X 0 ^ 3 * X 1 ^ 3 + 3 * X 0 ^ 2 * X 1 ^ 2 + 3 * X 0 * X 1 + 1 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul]
  ring

lemma d10 : pderiv 0 (F (K := K) 1) =
    9 * X 0 ^ 2 * X 1 ^ 2 * X 2 + 18 * X 0 * X 1 ^ 3 + 12 * X 0 * X 1 * X 2 + 12 * X 1 ^ 2 + 3 * X 2 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul, nsmul_eq_mul]
  ring

lemma d11 : pderiv 1 (F (K := K) 1) =
    6 * X 0 ^ 3 * X 1 * X 2 + 27 * X 0 ^ 2 * X 1 ^ 2 + 6 * X 0 ^ 2 * X 2 + 24 * X 0 * X 1 + 1 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul, nsmul_eq_mul]
  ring

lemma d12 : pderiv 2 (F (K := K) 1) =
    3 * X 0 ^ 3 * X 1 ^ 2 + 6 * X 0 ^ 2 * X 1 + 3 * X 0 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul]
  ring

lemma d20 : pderiv 0 (F (K := K) 2) =
    -3 * X 0 ^ 2 * X 2 - 6 * X 0 * X 1 + 2 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul, nsmul_eq_mul]
  ring

lemma d21 : pderiv 1 (F (K := K) 2) =
    -3 * X 0 ^ 2 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul]

lemma d22 : pderiv 2 (F (K := K) 2) =
    -X 0 ^ 3 := by
  simp [F, pderiv_X, Derivation.leibniz, Derivation.leibniz_pow, smul_eq_mul]

/-- The Jacobian determinant of `F` is the constant `-2`, over any field. -/
theorem jacobian_det :
    Matrix.det (fun i j => pderiv j (F (K := K) i)) = C (-2) := by
  change Matrix.det (Matrix.of fun i j => pderiv j (F (K := K) i)) = C (-2)
  rw [Matrix.det_fin_three]
  simp only [Matrix.of_apply, d00, d01, d02, d10, d11, d12, d20, d21, d22]
  rw [map_neg, map_ofNat]
  ring

end General

section Fiber

variable {K : Type*} [Field K]

/-- The three points of one fiber. -/
noncomputable def p₁ : Fin 3 → K := ![0, 0, -1 / 4]
noncomputable def p₂ : Fin 3 → K := ![1, -3 / 2, 13 / 2]
noncomputable def p₃ : Fin 3 → K := ![-1, 3 / 2, 13 / 2]

/-- The value of `F` on the fiber. -/
noncomputable def y : Fin 3 → K := ![-1 / 4, 0, 0]

theorem eval_p₁ : (fun j => eval p₁ (F (K := K) j)) = y := by
  funext j; fin_cases j <;> simp [F, p₁, y]

theorem eval_p₂ [CharZero K] : (fun j => eval p₂ (F (K := K) j)) = y := by
  funext j; fin_cases j <;> simp [F, p₂, y] <;> norm_num

theorem eval_p₃ [CharZero K] : (fun j => eval p₃ (F (K := K) j)) = y := by
  funext j; fin_cases j <;> simp [F, p₃, y] <;> norm_num

/-- If `G ∘ F = id` as polynomial maps, then `p = G(F(p))` for every point `p`. -/
lemma eq_eval_of_leftInverse (G : Fin 3 → MvPolynomial (Fin 3) K)
    (hGF : ∀ i, bind₁ F (G i) = X i) (p : Fin 3 → K) (i : Fin 3) :
    p i = eval (fun j => eval p (F j)) (G i) := by
  have h := congrArg (eval p) (hGF i)
  rw [eval_X] at h
  rw [← h]
  exact eval₂Hom_bind₁ (RingHom.id K) p F (G i)

/-- `F` has no polynomial left inverse over any field of characteristic zero. -/
theorem no_leftInverse [CharZero K] (G : Fin 3 → MvPolynomial (Fin 3) K)
    (hGF : ∀ i, bind₁ F (G i) = X i) : False := by
  have h₁ := eq_eval_of_leftInverse G hGF p₁ 0
  have h₂ := eq_eval_of_leftInverse G hGF p₂ 0
  rw [eval_p₁] at h₁
  rw [eval_p₂, ← h₁] at h₂
  simp [p₁, p₂] at h₂

end Fiber

/-- A field of characteristic zero in every universe. -/
instance charZero_ULift_rat : CharZero (ULift.{u} ℚ) :=
  RingHom.charZero (ULift.ringEquiv : ULift.{u} ℚ ≃+* ℚ).toRingHom

/-- **The JSP-000037 target is false**, in every universe `u`. -/
theorem not_target : ¬ Problem.Target.{u} := by
  intro h
  obtain ⟨G, -, hGF⟩ :=
    h (ULift.{u} ℚ) 3 (by norm_num) F ⟨-2, by norm_num, jacobian_det⟩
  exact no_leftInverse G hGF

end JacobianDisproof
