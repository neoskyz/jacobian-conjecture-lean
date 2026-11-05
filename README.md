# The Jacobian conjecture fails in dimension 3: a Lean 4 proof

A machine-checked Lean 4 formalization of L. Alpöge's 2026 counterexample to the Jacobian conjecture.
It proves that the map below has constant Jacobian determinant `-2` and still has no polynomial
inverse, over every field of characteristic zero.

> [!IMPORTANT]
> **MathDB shows "Lean verification did not pass" for this proof. The failure is in MathDB's own target file, not in this proof.**
> MathDB's frozen target `Sun_Jacobian.lean` has no module docstring. MathDB's own linter (`linter.style.moduleDocstring`, from `MathDBUtil`) warns on that file, and the verifier treats the warning as an error. Compiling the target alone, with no submission, reproduces the exact message, so every submission against this target fails the same way. This proof's own files compile with zero warnings under warnings-as-errors. Reported with steps to reproduce: [mathdb-lean/problems#9](https://github.com/mathdb-lean/problems/issues/9).

```
F₁ = (1 + z₁z₂)³ z₃ + z₂² (1 + z₁z₂)(4 + 3z₁z₂)
F₂ = z₂ + 3z₁ (1 + z₁z₂)² z₃ + 3z₁z₂² (4 + 3z₁z₂)
F₃ = 2z₁ − 3z₁²z₂ − z₁³z₃
```

## What is proved

All of the mathematics is in [`JacobianDisproof.lean`](JacobianDisproof.lean), which imports only Mathlib.

| Lean name | Statement |
|---|---|
| `jacobian_det` | `det (∂Fᵢ/∂zⱼ) = C (-2)`, over any field |
| `eval_p₁`, `eval_p₂`, `eval_p₃` | `F(0, 0, -1/4) = F(1, -3/2, 13/2) = F(-1, 3/2, 13/2) = (-1/4, 0, 0)` |
| `no_leftInverse` | no polynomial `G` satisfies `G ∘ F = id`, since `F` is not injective |
| `not_kellerAllDims` | Keller's statement for all dimensions `n ≥ 1` is false, in every universe |

How the proof goes:
- **Determinant:** the nine partial derivatives are computed by `simp`, then the 3×3 determinant is expanded and simplified with `ring`.
- **Three points, one image:** the three points are evaluated by `norm_num`.
- **No inverse:** a polynomial left inverse `G` would give `G(F(p)) = p` at every point `p`. That is impossible when two different points have the same image.

The statement only concerns dimension 3 and up. The plane case `n = 2` is still open, and this repository does not touch it.

## Build and check

Requirements: Lean `v4.33.1` and Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.

```sh
lake exe cache get
scripts/check_submission.sh
```

The script compiles everything with warnings treated as errors and prints the axioms the proof uses:

```
'Submission.solution' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `native_decide` or added axioms.

**MathDB.** [`Submission.lean`](Submission.lean) is the entry point for MathDB problem #315779. It proves `¬ Problem.Target`, because MathDB's frozen target `Sun_Jacobian.lean` states the conjecture in every dimension. MathDB supplies that target file, so it is not in this repository. Its verification status is explained in the note at the top of this page.

## Credit

The counterexample is due to Levent Alpöge
([announced July 19, 2026](https://x.com/__alpoge__/status/2079028340955197566)). This repository is an
independent Lean formalization by Zinan Xing, prepared with the assistance of AI.

License: [Apache-2.0](LICENSE).
