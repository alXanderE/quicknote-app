#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$HOME/quicknote-app"
APP_FILE="app.py"
PY="/usr/bin/python3.12"

cd "$APP_DIR"

# Pull latest code (rebase is risky in automation; use a clean sync)
git fetch --all
git reset --hard origin/main

# Ensure venv exists
if [ ! -d "venv" ]; then
  python3.12 -m venv venv
fi

# Install/update deps
"$PY" -m pip install -U pip
"$PY" -m pip install -r requirements.txt

# Stop previous process (if any) by matching the exact command
# This avoids killing unrelated python processes.
pkill -f "$PY $APP_FILE" || true

# Start new process
nohup "$PY" "$APP_FILE" > log.txt 2>&1 &

echo "Started. Tail logs with: tail -n 200 -f $APP_DIR/log.txt"