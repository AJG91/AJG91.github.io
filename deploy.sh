#!/bin/bash
# deploy.sh - build Jekyll site and push _site to GitHub

# Exit on error
set -e

echo "=== Starting deployment ==="

# Flag file to check if all posts have been cleaned once
FLAG_FILE=".cleaned_posts.flag"

if [ ! -f "$FLAG_FILE" ]; then
  echo "First run: normalizing all posts in _posts..."
  find _posts -name "*.md" -exec dos2unix {} \;
  # Mark that all posts have been cleaned
  touch "$FLAG_FILE"
else
  echo "Normalizing all changed posts (staged or unstaged)..."
  # Find all modified Markdown files in _posts
  CHANGED_POSTS=$(git diff --name-only --diff-filter=d HEAD | grep '^_posts/.*\.md$' || true)

  if [ -n "$CHANGED_POSTS" ]; then
    echo "$CHANGED_POSTS" | xargs -r dos2unix
  else
    echo "No changed posts to normalize."
  fi
fi

# Build the site
echo "Building Jekyll site..."
bundle exec jekyll clean
bundle exec jekyll build

# Go into _site
cd _site

# Safety check: ensure _site is not empty
if [ -z "$(ls -A .)" ]; then
    echo "Error: _site directory is empty. Aborting deploy."
    exit 1
fi

# Reset git repository to remove old history
if [ -d ".git" ]; then
    rm -rf .git
fi
git init
git remote add origin git@github.com:AJG91/AJG91.github.io.git

# Check for unrendered LaTeX using fixed grep
echo "Checking for unrendered LaTeX..."
unrendered_count=$(grep -RE '\\\(|\\\[|\$[^\$]' . --include \*.html --exclude-dir=_includes --exclude-dir=_layouts | wc -l)

if [ "$unrendered_count" -gt 0 ]; then
    echo "Warning: $unrendered_count potential unrendered LaTeX instances found."
    echo "Proceeding with commit and push anyway."
fi

# Add all changes
echo "Adding changes to git..."
git add .

# Commit with timestamp
commit_msg="Update site $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_msg" || echo "No changes to commit"

# Push to main branch
echo "Pushing to GitHub..."
git push -f origin main

echo "Deployment complete!"
