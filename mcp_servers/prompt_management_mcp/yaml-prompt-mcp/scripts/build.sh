#!/bin/bash
set -e

echo "Building YAML Prompt MCP package..."

# Build Python package
python -m build

# Build container image
podman build -t yaml-prompt-mcp:latest .

echo "Build complete!"
