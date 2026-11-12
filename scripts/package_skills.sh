#!/usr/bin/env bash
# Zips each skill in skills/ into dist/<skill-name>.zip for uploading to apps like Claude.
# Usage: ./scripts/package_skills.sh            (all skills)
#        ./scripts/package_skills.sh my-skill   (one skill)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/dist"
cd "$ROOT/skills"

if [ $# -gt 0 ]; then
  targets=("$@")
else
  targets=(*/)
fi

for dir in "${targets[@]}"; do
  name="${dir%/}"
  if [ ! -f "$name/SKILL.md" ]; then
    echo "Skipping $name (no SKILL.md)"
    continue
  fi
  rm -f "$ROOT/dist/$name.zip"
  zip -rq "$ROOT/dist/$name.zip" "$name" -x '*.DS_Store'
  echo "Built dist/$name.zip"
done
