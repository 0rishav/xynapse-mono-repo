#!/bin/bash
set -e

SERVICE_NAME=${1:-""}  # Service name input lो — unique tag ke liye

# Latest tag fetch karo
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")

# Validate format — v1.2.3 hona chahiye
if ! echo "$LATEST_TAG" | grep -qE "^v[0-9]+\.[0-9]+\.[0-9]+$"; then
  echo "WARNING: Tag '$LATEST_TAG' invalid format. Defaulting to v1.0.0"
  LATEST_TAG="v1.0.0"
fi

VERSION=$(echo $LATEST_TAG | sed 's/v//')
MAJOR=$(echo $VERSION | cut -d. -f1)
MINOR=$(echo $VERSION | cut -d. -f2)
PATCH=$(echo $VERSION | cut -d. -f3)

# Commit message se bump type decide karo
COMMIT_MSG=$(git log -1 --pretty=%B)

if echo "$COMMIT_MSG" | grep -qiE "BREAKING CHANGE|major:"; then
  MAJOR=$((MAJOR + 1))
  MINOR=0
  PATCH=0
  BUMP_TYPE="MAJOR"
elif echo "$COMMIT_MSG" | grep -qiE "^feat:|^feature:"; then
  MINOR=$((MINOR + 1))
  PATCH=0
  BUMP_TYPE="MINOR"
else
  PATCH=$((PATCH + 1))
  BUMP_TYPE="PATCH"
fi

NEW_TAG="v$MAJOR.$MINOR.$PATCH"

# Service specific tag — parallel jobs me conflict nahi hoga
if [ -n "$SERVICE_NAME" ]; then
  NEW_TAG="${NEW_TAG}-${SERVICE_NAME}-${GITHUB_SHA::7}"
fi

echo "Bump Type: $BUMP_TYPE"
echo "Previous Tag: $LATEST_TAG"
echo "Final Version: $NEW_TAG"

echo "NEW_TAG=$NEW_TAG" >> $GITHUB_ENV