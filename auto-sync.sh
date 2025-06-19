#!/bin/bash

echo "🚀 Starting PayrollPro with Auto-Commit on Inactivity..."

# Git config
git config user.name "dev-itredstone"
git config user.email "dev.itredstone@gmail.com"

# Set watch directory
WATCH_DIR="./"
INACTIVITY_SECONDS=30

# Get initial timestamp
last_change=$(find "$WATCH_DIR" -type f -not -path './.git/*' -printf '%T@\n' | sort -nr | head -n 1)

while true; do
  sleep 5

  # Get current latest timestamp
  current_change=$(find "$WATCH_DIR" -type f -not -path './.git/*' -printf '%T@\n' | sort -nr | head -n 1)

  # If no new changes
  if [[ "$last_change" == "$current_change" ]]; then
    elapsed=$(( $(date +%s) - ${last_push:-0} ))
    if [[ $elapsed -ge $INACTIVITY_SECONDS ]]; then
      echo "💤 No file changes for $INACTIVITY_SECONDS seconds. Attempting auto-commit..."

      if [ -n "$(git status --porcelain)" ]; then
        git add .
        git commit -m "🌀 Auto-commit from Replit on $(date '+%Y-%m-%d %H:%M:%S')" && \
        git push origin main && \
        echo "✅ Code auto-pushed to GitHub." || \
        echo "❌ Push failed"
      else
        echo "🟢 No changes to commit."
      fi

      last_push=$(date +%s)
    fi
  else
    last_change=$current_change
    last_push=$(date +%s)
  fi
done
