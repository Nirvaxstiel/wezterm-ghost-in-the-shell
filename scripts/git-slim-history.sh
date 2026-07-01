#!/usr/bin/env bash
# git-slim-history.sh — on-demand history cleanup for oversized blobs
#
# Strips blobs over MAX_SIZE from ALL commits, prunes stale refs, repacks.
# Format-agnostic — size is the only gate. Run when history has bloat.
#
# Usage:
#   bash scripts/git-slim-history.sh          # strip + repack
#   bash scripts/git-slim-history.sh --check   # report only, no changes
#
# Requirements: git-filter-repo (pip install git-filter-repo)
# NOTE: Rewrites history. Force-push required after running.
#       Remote-tracking branches are pruned (git fetch to restore them).

set -euo pipefail

MAX_SIZE=$((4 * 1024 * 1024))  # 4MB per blob

cd "$(git rev-parse --show-toplevel)"

if ! git filter-repo --version >/dev/null 2>&1; then
  echo "error: git-filter-repo not installed. Run: pip install git-filter-repo"
  exit 1
fi

CHECK_ONLY=0
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=1

# Find blobs over MAX_SIZE in history (whitespace-safe via --batch-check)
STALE=$(git rev-list --objects --all \
  | git cat-file --batch-check='%(objecttype) %(objectsize) %(objectname) %(rest)' \
  | awk -v max="$MAX_SIZE" '$1=="blob" && $2 > max {print $3" "$2" "$4}')

STALE_COUNT=$(echo "$STALE" | grep -c . || true)

if [[ "$STALE_COUNT" -eq 0 ]]; then
  echo "No blobs over 4MB in history. Nothing to clean."
  exit 0
fi

echo "Found $STALE_COUNT oversized blob(s) in history:"
echo "$STALE" | awk '{printf "  %.1fMB\t%s\n", $2/1048576, $3}'
TOTAL_MB=$(echo "$STALE" | awk '{sum+=$2} END {printf "%.1f", sum/1048576}')
echo "Total reclaimable: ${TOTAL_MB}MB"

if [[ "$CHECK_ONLY" -eq 1 ]]; then
  exit 0
fi

echo ""
echo "Rewriting history to strip blobs over 4MB..."
git filter-repo --force --strip-blobs-bigger-than "${MAX_SIZE}" 2>&1

# filter-repo strips all remotes — re-add them
for remote in origin codeberg gitlab; do
  case "$remote" in
    origin)   url="git@github.com:Nirvaxstiel/wezterm-ghost-in-the-shell.git" ;;
    codeberg) url="ssh://git@codeberg.org/Nirvaxstiel/wezterm-ghost-in-the-shell.git" ;;
    gitlab)   url="git@gitlab.com:Nirvaxstiel/wezterm-ghost-in-the-shell.git" ;;
  esac
  if ! git remote get-url "$remote" >/dev/null 2>&1; then
    git remote add "$remote" "$url"
    echo "Re-added $remote remote."
  fi
done

# Prune stale remote-tracking refs, reflog, filter-repo metadata, then repack
echo "Pruning stale refs and repacking..."
git for-each-ref --format='%(refname)' refs/remotes/ | while read -r ref; do
  git update-ref -d "$ref"
done
git reflog expire --expire=now --all
rm -rf .git/filter-repo
rm -f .git/ORIG_HEAD
git gc --prune=now --aggressive

echo ""
echo "Done. .git size: $(du -sh .git | cut -f1)"
echo "Force-push required for all remotes:"
git remote -v | awk '{print "  git push --force " $1 " master"}' | sort -u