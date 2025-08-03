#!/bin/bash
# Directory structure for publishing the YAML Prompt MCP

# Create the publishing structure
mkdir -p yaml-prompt-mcp/{src/yaml_prompt_mcp,manifests/{base,overlays/{dev,staging,prod}},scripts,docs,examples}

# Core Python package structure
cat > yaml-prompt-mcp/pyproject.toml << 'EOF'
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "yaml-prompt-mcp"
version = "1.0.0"
description = "YAML-based prompt management for FastMCP servers"
authors = [{name = "Your Organization"}]
dependencies = [
    "fastmcp>=2.0.0",
    "pyyaml>=6.0",
    "pydantic>=2.0.0"
]
requires-python = ">=3.10"

[project.scripts]
yaml-prompt-mcp = "yaml_prompt_mcp.cli:main"

[project.optional-dependencies]
dev = ["pytest", "pytest-cov", "black", "ruff"]
EOF

# Package structure
cat > yaml-prompt-mcp/src/yaml_prompt_mcp/__init__.py << 'EOF'
"""YAML-based prompt management for FastMCP servers"""
from .manager import YAMLPromptManager
from .server import create_prompt_server
from .cli import main

__version__ = "1.0.0"
__all__ = ["YAMLPromptManager", "create_prompt_server", "main"]
EOF

# CLI entry point
cat > yaml-prompt-mcp/src/yaml_prompt_mcp/cli.py << 'EOF'
#!/usr/bin/env python3
"""CLI for running YAML Prompt MCP servers"""
import argparse
import sys
from pathlib import Path
from .server import create_prompt_server

def main():
    parser = argparse.ArgumentParser(description="YAML Prompt MCP Server")
    parser.add_argument("--prompts-dir", default="prompts", 
                       help="Directory containing YAML prompt files")
    parser.add_argument("--name", default="YAML Prompt Server",
                       help="Server name")
    parser.add_argument("--transport", choices=["stdio", "http", "sse"], 
                       default="stdio", help="Transport protocol")
    parser.add_argument("--host", default="0.0.0.0", help="Host for HTTP/SSE")
    parser.add_argument("--port", type=int, default=8000, help="Port for HTTP/SSE")
    
    args = parser.parse_args()
    
    if not Path(args.prompts_dir).exists():
        print(f"Error: Prompts directory '{args.prompts_dir}' does not exist")
        sys.exit(1)
    
    server = create_prompt_server(args.name, args.prompts_dir)
    
    if args.transport == "stdio":
        server.run()
    elif args.transport == "http":
        server.run(transport="http", host=args.host, port=args.port)
    elif args.transport == "sse":
        server.run(transport="sse", host=args.host, port=args.port)

if __name__ == "__main__":
    main()
EOF

# Containerfile using Red Hat UBI
cat > yaml-prompt-mcp/Containerfile << 'EOF'
FROM registry.redhat.io/ubi9/python-311:latest

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY pyproject.toml ./
RUN pip install --no-cache-dir .

# Copy source code
COPY src/ ./src/
COPY prompts/ ./prompts/

# Install the package
RUN pip install --no-cache-dir -e .

# Create non-root user
USER 1001

# Expose port for HTTP/SSE modes
EXPOSE 8000

# Default to stdio transport
CMD ["yaml-prompt-mcp", "--transport", "stdio"]
EOF

# OpenShift base manifests
cat > yaml-prompt-mcp/manifests/base/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: yaml-prompt-mcp
  labels:
    app: yaml-prompt-mcp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: yaml-prompt-mcp
  template:
    metadata:
      labels:
        app: yaml-prompt-mcp
    spec:
      containers:
      - name: yaml-prompt-mcp
        image: yaml-prompt-mcp:latest
        ports:
        - containerPort: 8000
        env:
        - name: TRANSPORT
          value: "http"
        - name: HOST
          value: "0.0.0.0"
        - name: PORT
          value: "8000"
        command: ["yaml-prompt-mcp"]
        args: ["--transport", "$(TRANSPORT)", "--host", "$(HOST)", "--port", "$(PORT)"]
        volumeMounts:
        - name: prompts-volume
          mountPath: /app/prompts
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "500m"
      volumes:
      - name: prompts-volume
        configMap:
          name: yaml-prompt-mcp-prompts
---
apiVersion: v1
kind: Service
metadata:
  name: yaml-prompt-mcp-service
spec:
  selector:
    app: yaml-prompt-mcp
  ports:
  - port: 8000
    targetPort: 8000
  type: ClusterIP
EOF

cat > yaml-prompt-mcp/manifests/base/kustomization.yaml << 'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- deployment.yaml

configMapGenerator:
- name: yaml-prompt-mcp-prompts
  files:
  - ../../examples/prompts/
EOF

# Production overlay example
cat > yaml-prompt-mcp/manifests/overlays/prod/kustomization.yaml << 'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- ../../base

patchesStrategicMerge:
- deployment-patch.yaml

replicas:
- name: yaml-prompt-mcp
  count: 3
EOF

cat > yaml-prompt-mcp/manifests/overlays/prod/deployment-patch.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: yaml-prompt-mcp
spec:
  template:
    spec:
      containers:
      - name: yaml-prompt-mcp
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
EOF

# Build and deployment scripts
cat > yaml-prompt-mcp/scripts/build.sh << 'EOF'
#!/bin/bash
set -e

echo "Building YAML Prompt MCP package..."

# Build Python package
python -m build

# Build container image
podman build -t yaml-prompt-mcp:latest .

echo "Build complete!"
EOF

cat > yaml-prompt-mcp/scripts/deploy-openshift.sh << 'EOF'
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
EOF

# Example prompts for testing
mkdir -p yaml-prompt-mcp/examples/prompts

cat > yaml-prompt-mcp/examples/prompts/example.yaml << 'EOF'
name: "Example Prompt"
description: "A simple example prompt for testing"
template: |
  Hello, {name}! 
  
  You are a helpful assistant. Please help with: {task}

parameters:
  - temperature: 0.7
  - max_tokens: 1000

variables:
  - name: "name"
    type: "string"
    description: "Name of the user"
    required: true
  - name: "task"
    type: "string" 
    description: "Task to help with"
    required: true
EOF

# Documentation
cat > yaml-prompt-mcp/README.md << 'EOF'
# YAML Prompt MCP

A FastMCP server that manages prompts stored in YAML files, enabling easy editing and version control of AI prompts across applications.

## Installation

### As a Python Package
```bash
pip install yaml-prompt-mcp
```

### As a Container
```bash
podman pull your-registry/yaml-prompt-mcp:latest
```

## Usage

### Standalone Server
```bash
# Stdio transport (default)
yaml-prompt-mcp --prompts-dir ./prompts

# HTTP transport
yaml-prompt-mcp --transport http --host 0.0.0.0 --port 8000
```

### In Your Application
```python
from yaml_prompt_mcp import create_prompt_server

server = create_prompt_server("My Prompts", "prompts/")
server.run()
```

### OpenShift Deployment
```bash
./scripts/deploy-openshift.sh prod my-namespace
```

## Prompt Format

See `examples/prompts/` for YAML prompt format examples.

## Architecture

- **Library**: Reusable `YAMLPromptManager` class
- **CLI**: Standalone server executable  
- **Container**: Red Hat UBI-based container image
- **OpenShift**: Production-ready manifests with Kustomize overlays
EOF

chmod +x yaml-prompt-mcp/scripts/*.sh

echo "YAML Prompt MCP publishing structure created!"
echo ""
echo "Publishing options:"
echo "1. Internal PyPI: pip install from your private repository"
echo "2. Container Registry: podman push to your OpenShift registry"
echo "3. Git Template: Clone and customize for each team"
echo "4. Helm Chart: Package as a Helm chart for easy deployment"