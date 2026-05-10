#!/bin/bash

# Target Dockerfile path input se aayega
DOCKERFILE_PATH=$1

echo "Starting Deep Security Audit: $DOCKERFILE_PATH"

# The 'latest' Tag Poisoning
if grep -q "FROM .*latest" "$DOCKERFILE_PATH"; then
    echo "SECURITY FAILURE: Base image uses 'latest' tag. Please use a specific version or SHA256 hash."
    exit 1
fi

# The Root User Vulnerability
if ! grep -q "USER " "$DOCKERFILE_PATH"; then
    echo "SECURITY FAILURE: No 'USER' instruction found. Containers must not run as ROOT."
    exit 1
fi

# Hardcoded Secrets (Leaked Credentials)

if grep -qE "PASSWORD|SECRET|TOKEN|API_KEY|PRIVATE_KEY" "$DOCKERFILE_PATH"; then
    echo "SECURITY FAILURE: Potential hardcoded secret/key detected in Dockerfile instructions."
    exit 1
fi

# Update/Upgrade Command Safety'

if grep -q "apt-get upgrade" "$DOCKERFILE_PATH"; then
    echo "WARNING: 'apt-get upgrade' detected. Better to use a secure base image instead of upgrading at build time."
fi

# Workdir Consistency

if ! grep -q "WORKDIR " "$DOCKERFILE_PATH"; then
    echo "FAILURE: WORKDIR not defined. Don't build in the root directory of the container."
    exit 1
fi

echo "Audit Passed! All security locks are engaged."
exit 0