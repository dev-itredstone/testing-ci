#!/bin/bash

echo "🚀 Starting PayrollPro with Auto-Commit..."

# Configure git
git config user.name "dev-itredstone"
git config user.email "dev.itredstone@gmail.com"

# Function to commit and push changes
auto_commit() {
  if [ -n "$(git status --porcelain)" ]; then
    echo "📁 Changes detected, committing..."
    git add .
    git commit -m "🌀 Auto-commit from Replit on $(date '+%Y-%m-%d %H:%M:%S')"
    if git push origin main; then
      echo "✅ Changes pushed successfully"
    else
      echo "❌ Push failed"
    fi
  fi
}

# Start background auto-commit loop
(
  echo "🔍 Starting auto-commit monitor..."
  while true; do
    sleep 10  # Check every 10 seconds
    auto_commit
  done
) &

echo "💡 Auto-commit is running in background"
echo "🚀 Starting npm dev server..."

# Start the main application
exec npm run dev