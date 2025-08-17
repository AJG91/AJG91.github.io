#!/bin/bash
# deploy.sh - build Jekyll site and push _site to GitHub

# Exit on error
set -e

# Build the site
echo "Building Jekyll site..."
bundle exec jekyll build

# Go into _site
cd _site

# Add all changes
echo "Adding changes to git..."
git add .

# Commit with timestamp
commit_msg="Update site $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_msg" || echo "No changes to commit"

# Push to main branch
echo "Pushing to GitHub..."
git push -u origin main

echo "Deployment complete!"
