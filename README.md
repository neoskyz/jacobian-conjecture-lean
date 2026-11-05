# The JSP-000037 Lean target is false

A machine-checked proof of `¬ Problem.Target` for the Lean statement attached to
MathDB problem #315779 (Justin Sun Prize JSP-000037, Jacobian conjecture):
`Sun_Jacobian.lean`, sha256 `97f1d4ffe39182db16ed33cfb6f1df24c43e2a9a25c544ed6b131ca71f9a6a7a`.

## Statement correspondence

The frozen target is MathDB's
[`Sun_Jacobian.lean`](https://github.com/mathdb-lean/problems/blob/924bd70ab97fcf6f1eda41dac7ee1be7e0bc8bda/additional-statements/315779/Sun_Jacobian.lean)
(module `FtpEvalBench.Sun_Jacobian`, sha256 `97f1d4ffe39182db16ed33cfb6f1df24c43e2a9a25c544ed6b131ca71f9a6a7a`).
It states that over every field of characteristic zero, in every dimension `n ≥ 1`, a polynomial
map with constant nonzero Jacobian determinant has a two-sided polynomial inverse. MathDB supplies
this module to its checker, so it is not part of this repository.

- `JacobianDisproof.lean` defines `KellerAllDims`, verbatim the body of `Problem.Target`, and proves
  `JacobianDisproof.not_kellerAllDims : ¬ KellerAllDims.{u}` for every universe `u` (the field is
  `ULift.{u} ℚ`). It imports only Mathlib.
- `Submission.lean` (root, the MathDB entry point) imports the unchanged target and exports

```lean
theorem Submission.solution : ¬ Problem.Target.{u}
```

Because the target is false, the entry point has type `¬ Problem.Target`, not `Problem.Target`.
It refutes the general-dimension statement; it does not settle the plane case `n = 2`.

The witness is the map `F : K³ → K³` announced by L. Alpöge on July 19, 2026:

```
F₁ = (1 + z₁z₂)³ z₃ + z₂² (1 + z₁z₂)(4 + 3z₁z₂)
F₂ = z₂ + 3z₁ (1 + z₁z₂)² z₃ + 3z₁z₂² (4 + 3z₁z₂)
F₃ = 2z₁ − 3z₁²z₂ − z₁³z₃
```

- `jacobian_det`: its Jacobian determinant is the constant `-2` (over any field);
- `eval_p₁`, `eval_p₂`, `eval_p₃`: `F(0, 0, -1/4) = F(1, -3/2, 13/2) = F(-1, 3/2, 13/2) = (-1/4, 0, 0)`;
- `no_leftInverse`: so no polynomial `G` satisfies `G ∘ F = id` (the target's second conjunct).

## Build and check

Lean `v4.33.1` and Mathlib `0df444a360eaa60ab8c11dca51a86af692955474` (MathDB's frozen environment for
this target), through `mathdb-lean/problems` at `aa532247d0301aca9a1c62f119920622f465878b`, which provides
`MathDBUtil` (imported by the target).

```sh
lake exe cache get
scripts/check_submission.sh
```

The script fetches the frozen target, checks its sha256, compiles it, then compiles
`JacobianDisproof.lean` and `Submission.lean` with warnings as errors and the full Mathlib linter set,
and prints the axioms:

```
'Submission.solution' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `native_decide`, added axioms or `set_option`.

## Credit

The counterexample is due to Levent Alpöge
([announced July 19, 2026](https://x.com/__alpoge__/status/2079028340955197566); see also the sources
listed on [MathDB #315779](https://mathdb.com/p/315779)). This repository is an independent Lean
formalization of the fact that it refutes the target statement, by Zinan Xing, prepared with the
assistance of AI.

License: [Apache-2.0](LICENSE).
