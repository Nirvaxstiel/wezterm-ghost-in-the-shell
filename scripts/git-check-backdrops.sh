#!/usr/bin/env bash
# git-check-backdrops.sh — pre-commit guard against oversized backdrops
#
# Installed as pre-commit hook. Blocks commits that add files under backdrops/
# exceeding MAX_SIZE bytes.
#
# Install:   cp scripts/git-check-backdrops.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
# Or core.hooksPath:  git config core.hooksPath hooks  (then copy there)

set -euo pipefail

MAX_SIZE=$((4 * 1024 * 1024))  # 4MB per file

errors=0

while IFS= read -r -d '' f; do
  if [[ -f "$f" ]]; then
    size=$(stat --format=%s "$f" 2>/dev/null || stat -f%z "$f" 2>/dev/null || echo 0)
    if [[ "$size" -gt "$MAX_SIZE" ]]; then
      size_mb=$((size / 1024 / 1024))
      echo "ERROR: $f is ${size_mb}MB (max 4MB) — compress or omit"
      errors=$((errors + 1))
    fi
  fi
done < <(git diff --cached --name-only -z --diff-filter=ACM -- 'backdrops/')

if [[ "$errors" -gt 0 ]]; then
  echo ""
  echo "Commit blocked: $errors oversized file(s) in backdrops/"
  echo "Compress under 4MB, then re-stage."
  exit 1
fi

exit 0