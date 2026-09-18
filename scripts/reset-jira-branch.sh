#!/usr/bin/env bash

TARGET_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
JIRA_KEY=$(echo "$CURRENT_BRANCH" | grep -oE '[A-Za-z]+-[0-9]+' | head -n 1)

TEMP_BRANCH="$CURRENT_BRANCH"

if [ -z "$JIRA_KEY" ]; then
  echo "Error: No JIRA issue number found in current branch name ('$CURRENT_BRANCH')."
  exit 1
fi

echo "Extracted JIRA Key: $JIRA_KEY"

git checkout "$TARGET_BRANCH" || exit 1
git branch -D "$CURRENT_BRANCH"
git pull || exit 1

NEW_BRANCH="$TEMP_BRANCH"
git checkout -b "$NEW_BRANCH"
echo "Successfully created new branch '$NEW_BRANCH' from '$TARGET_BRANCH'."