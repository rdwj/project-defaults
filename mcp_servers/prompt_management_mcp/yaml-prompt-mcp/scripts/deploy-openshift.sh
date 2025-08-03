#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}
NAMESPACE=${2:-yaml-prompt-mcp}

echo "Deploying to OpenShift environment: $ENVIRONMENT"

# Create namespace if it doesn't exist
oc create namespace $NAMESPACE --dry-run=client -o yaml | oc apply -f -

# Apply manifests
oc apply -k manifests/overlays/$ENVIRONMENT -n $NAMESPACE

echo "Deployment complete!"
echo "Service available at: yaml-prompt-mcp-service.$NAMESPACE.svc.cluster.local:8000"
