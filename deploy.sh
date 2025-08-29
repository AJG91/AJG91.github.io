#!/bin/bash
# deploy.sh - build Jekyll site and push _site to GitHub

# Exit on error
set -e

# Build the site
echo "Building Jekyll site..."
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
