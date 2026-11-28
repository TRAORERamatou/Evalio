#!/usr/bin/env bash
# Checks that code changes in api/src/ or app/lib/ include corresponding test changes.
# Limitation: this guard checks file PRESENCE only, never test quality; human review remains essential.
set -euo pipefail

BASE_REF="${BASE_REF:-main}"
PR_BODY="${PR_BODY:-}"
HAS_EXEMPT_LABEL="${HAS_EXEMPT_LABEL:-false}"

CHANGED_FILES="$(git diff --name-only "origin/${BASE_REF}...HEAD")"

API_CODE="$(echo "$CHANGED_FILES" | grep -E '^api/src/.*\.ts$' | grep -vE '(\.d\.ts$|^api/src/config/|^api/src/types/|\.types\.ts$)' || true)"
API_TESTS="$(echo "$CHANGED_FILES" | grep -E '^(api/test/.*|api/.*\.(test|spec)\.ts)$' || true)"

APP_CODE="$(echo "$CHANGED_FILES" | grep -E '^app/lib/.*\.dart$' | grep -vE '(\.g\.dart$|\.freezed\.dart$|\.gr\.dart$|^app/lib/l10n/|^app/lib/generated/)' || true)"
APP_TESTS="$(echo "$CHANGED_FILES" | grep -E '^app/test/.*' || true)"

if [ -z "$API_CODE" ] && [ -z "$APP_CODE" ]; then
  echo "OK: aucun fichier de code modifié."
  exit 0
fi

# Check explicit exemption: label 'no-tests-needed' AND non-empty 'Tests-exemption: <reason>' in PR body
EXEMPTION_REASON="$(printf '%s\n' "$PR_BODY" | sed -n 's/^[Tt]ests-[Ee]xemption:[[:space:]]*//p' | head -n 1 | xargs || true)"
if [ "$HAS_EXEMPT_LABEL" = "true" ] && [ -n "$EXEMPTION_REASON" ]; then
  echo "::warning::Tests-present bypassed via 'no-tests-needed' label. Reason: ${EXEMPTION_REASON}"
  exit 0
fi

FAILED=0
if [ -n "$API_CODE" ] && [ -z "$API_TESTS" ]; then
  echo "::error::api/src/ modified without any test file in api/test/ (or *.test.ts/*.spec.ts). Add tests or apply label 'no-tests-needed' with 'Tests-exemption: <reason>'."
  FAILED=1
fi

if [ -n "$APP_CODE" ] && [ -z "$APP_TESTS" ]; then
  echo "::error::app/lib/ modified without any test file in app/test/. Add tests or apply label 'no-tests-needed' with 'Tests-exemption: <reason>'."
  FAILED=1
fi

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "OK: code changes include corresponding test changes."
