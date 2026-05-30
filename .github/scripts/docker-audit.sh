#!/bin/bash
set -e

DOCKERFILE_PATH=$1

if [ -z "$DOCKERFILE_PATH" ]; then
  echo "FAILURE: No Dockerfile path provided."
  exit 1
fi

if [ ! -f "$DOCKERFILE_PATH" ]; then
  echo "FAILURE: Dockerfile not found at path: $DOCKERFILE_PATH"
  exit 1
fi

echo "Starting Deep Security Audit: $DOCKERFILE_PATH"

FAILED=0

# 1. 'latest' Tag Poisoning
if grep -qE "^FROM .*:latest" "$DOCKERFILE_PATH"; then
  echo "SECURITY FAILURE: Base image uses 'latest' tag. Use a specific version or SHA256 hash."
  FAILED=1
fi

# 2. Root User Vulnerability - USER exist kare aur root na ho
if ! grep -qE "^USER " "$DOCKERFILE_PATH"; then
  echo "SECURITY FAILURE: No USER instruction found. Containers must not run as ROOT."
  FAILED=1
elif grep -qE "^USER (root|0)$" "$DOCKERFILE_PATH"; then
  echo "SECURITY FAILURE: Container is explicitly running as ROOT user."
  FAILED=1
fi

# 3. Hardcoded Secrets - sirf ENV aur ARG lines me check karo
if grep -E "^(ENV|ARG) " "$DOCKERFILE_PATH" | grep -qE "(PASSWORD|SECRET|TOKEN|API_KEY|PRIVATE_KEY)=.+"; then
  echo "SECURITY FAILURE: Potential hardcoded secret detected in ENV/ARG instructions."
  FAILED=1
fi

# 4. apt-get upgrade warning
if grep -q "apt-get upgrade" "$DOCKERFILE_PATH"; then
  echo "WARNING: 'apt-get upgrade' detected. Use a secure base image instead."
fi

# 5. WORKDIR check
if ! grep -qE "^WORKDIR " "$DOCKERFILE_PATH"; then
  echo "FAILURE: WORKDIR not defined. Don't build in root directory of container."
  FAILED=1
fi

# Final result
if [ $FAILED -eq 1 ]; then
  echo "Audit FAILED! Fix the above issues before proceeding."
  exit 1
fi

echo "Audit Passed! All security locks are engaged."
exit 0