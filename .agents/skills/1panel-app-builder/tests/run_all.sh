#!/usr/bin/env bash
set -euo pipefail
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SKILL_DIR"

bash -n scripts/download-icon.sh
bash -n scripts/generate-app.sh
bash -n scripts/validate-app.sh
python3 -m py_compile scripts/compose-helper.py
bash -n tests/test_skills_scripts.sh

bash tests/test_skills_scripts.sh

echo 'All skill checks passed.'
