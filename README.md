# The JSP-000037 Lean target is false

A machine-checked proof of `¬ Problem.Target` for the Lean statement attached to
MathDB problem #315779 (Justin Sun Prize JSP-000037, Jacobian conjecture):
`Sun_Jacobian.lean`, sha256 `97f1d4ffe39182db16ed33cfb6f1df24c43e2a9a25c544ed6b131ca71f9a6a7a`.

## Statement correspondence

`FtpEvalBench/Sun_Jacobian.lean` is the target file, byte-identical to
[mathdb-lean/problems@924bd70 `additional-statements/315779/Sun_Jacobian.lean`](https://github.com/mathdb-lean/problems/blob/924bd70ab97fcf6f1eda41dac7ee1be7e0bc8bda/additional-statements/315779/Sun_Jacobian.lean)
(module name `FtpEvalBench.Sun_Jacobian`, as in MathDB's record). It states that over every
field of characteristic zero, in every dimension `n ≥ 1`, a polynomial map with constant nonzero
Jacobian determinant has a two-sided polynomial inverse.

`JacobianDisproof.lean` proves

```lean
theorem JacobianDisproof.not_target : ¬ Problem.Target.{u}
```

The MathDB entry point is `Submission.lean`, which imports the unchanged target and exports

```lean
theorem Submission.solution : ¬ Problem.Target.{u}
```

Because the target is false, the entry point has type `¬ Problem.Target`, not `Problem.Target`.
It refutes the general-dimension statement; it does not settle the plane case `n = 2`.

for every universe `u` (the field used is `ULift.{u} ℚ`).

The witness is the map `F : K³ → K³` announced by L. Alpöge on July 19, 2026:

```
F₁ = (1 + z₁z₂)³ z₃ + z₂² (1 + z₁z₂)(4 + 3z₁z₂)
F₂ = z₂ + 3z₁ (1 + z₁z₂)² z₃ + 3z₁z₂² (4 + 3z₁z₂)
F₃ = 2z₁ − 3z₁²z₂ − z₁³z₃
```

- `jacobian_det`: its Jacobian determinant is the constant `-2` (over any field);
- `eval_p₁`, `eval_p₂`, `eval_p₃`: `F(0, 0, -1/4) = F(1, -3/2, 13/2) = F(-1, 3/2, 13/2) = (-1/4, 0, 0)`;
- `no_leftInverse`: so no polynomial `G` satisfies `G ∘ F = id` (the second conjunct of the target).

## Build

Environment: MathDB's recorded environment for this target, Lean `v4.33.1` and mathlib
`0df444a360eaa60ab8c11dca51a86af692955474`, obtained through the `mathdb-lean/problems` project at
`aa532247d0301aca9a1c62f119920622f465878b` (the last commit of that project pinned to this environment;
it provides `MathDBUtil`).

```sh
lake exe cache get
lake build
lake env lean scripts/Audit.lean
```

## Axioms

```
'JacobianDisproof.not_target' depends on axioms: [propext, Classical.choice, Quot.sound]
'Submission.solution' depends on axioms: [propext, Classical.choice, Quot.sound]
```

No `sorry`, `admit`, `native_decide`, added axioms or `set_option`s.

## Credit

The counterexample is due to Levent Alpöge
([announced July 19, 2026](https://x.com/__alpoge__/status/2079028340955197566); see also the sources
listed on [MathDB #315779](https://mathdb.com/p/315779)). This repository is an independent Lean
formalization of the fact that it refutes the target statement, by Zinan Xing, prepared with the
assistance of AI.

License: [Apache-2.0](LICENSE).
