#!/usr/bin/env bash
# Check the MathDB entry point the way MathDB's checker sees it: the frozen target is fetched and
# compiled separately (it is not part of this repo), then Submission.lean is compiled against it.
# Our modules are compiled with warnings as errors and the full Mathlib linter set.
set -euo pipefail
cd "$(dirname "$0")/.."
URL=https://raw.githubusercontent.com/mathdb-lean/problems/924bd70ab97fcf6f1eda41dac7ee1be7e0bc8bda/additional-statements/315779/Sun_Jacobian.lean
SHA=97f1d4ffe39182db16ed33cfb6f1df24c43e2a9a25c544ed6b131ca71f9a6a7a
F=.frozen/src/FtpEvalBench/Sun_Jacobian.lean
mkdir -p .frozen/src/FtpEvalBench .frozen/build/FtpEvalBench
curl -fsSL "$URL" -o "$F"
echo "$SHA  $F" | shasum -a 256 -c -
lake build
LP="$(lake env printenv LEAN_PATH):$PWD/.frozen/build"
STRICT=(-DwarningAsError=true -Dweak.linter.mathlibStandardSet=true)
LEAN_PATH=$LP lean -o .frozen/build/FtpEvalBench/Sun_Jacobian.olean "$F"
LEAN_PATH=$LP lean "${STRICT[@]}" JacobianDisproof.lean
LEAN_PATH=$LP lean "${STRICT[@]}" -o .frozen/build/Submission.olean Submission.lean
printf 'import Submission\n#check @Submission.solution\n#print axioms Submission.solution\n' > .frozen/Axioms.lean
LEAN_PATH=$LP lean .frozen/Axioms.lean
echo "check_submission: OK"
