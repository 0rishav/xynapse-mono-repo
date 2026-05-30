#!/bin/bash
set -e

# Retry setup
MAX_RETRIES=3
RETRY_COUNT=0

# Cluster Config
CLUSTER_NAME="xynapse-dev-gke"
REGION="asia-south1"

echo "Connecting to cluster..."
gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $GCP_PROJECT_ID

helm repo add actions-runner-controller https://actions.github.io/actions-runner-controller
helm repo update

deploy_arc() {
  echo "Installing ARC Controller..."
  helm upgrade --install arc \
    actions-runner-controller/gha-runner-scale-set-controller \
    --namespace arc-systems --create-namespace

  echo "Installing Runner Scale Set..."
  helm upgrade --install xynapse-runner-set \
    actions-runner-controller/gha-runner-scale-set \
    --namespace arc-runners --create-namespace \
    --set githubConfigUrl="https://github.com/$REPO_OWNER/$REPO_NAME" \
    --set githubConfigSecret.github_token=$GITHUB_TOKEN
}

# Retry loop
until [ $RETRY_COUNT -ge $MAX_RETRIES ]; do
  deploy_arc && echo "Deployment Successful!" && exit 0
  RETRY_COUNT=$((RETRY_COUNT + 1))
  echo "Attempt $RETRY_COUNT failed. Retrying in 10 seconds..."
  sleep 10
done

echo "Deployment failed after $MAX_RETRIES attempts."
exit 1