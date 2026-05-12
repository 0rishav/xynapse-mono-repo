#!/bin/bash

LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")

VERSION=$(echo $LATEST_TAG | sed 's/v//')
MAJOR=$(echo $VERSION | cut -d. -f1)
MINOR=$(echo $VERSION | cut -d. -f2)
PATCH=$(echo $VERSION | cut -d. -f3)

NEW_PATCH=$((PATCH + 1))
NEW_TAG="v$MAJOR.$MINOR.$NEW_PATCH"

echo "NEW_TAG=$NEW_TAG" >> $GITHUB_ENV
echo "Final Version: $NEW_TAG"