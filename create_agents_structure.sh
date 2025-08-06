#!/bin/bash

# Create agents directory structure for Claude Code sub-agents

echo "Creating agents directory structure..."

# Create main agents directory
mkdir -p agents

# Create sub-agent directories
mkdir -p agents/code-reviewer
mkdir -p agents/test-runner
mkdir -p agents/dependency-analyzer
mkdir -p agents/openshift-deployer
mkdir -p agents/security-scanner
mkdir -p agents/mcp-generator
mkdir -p agents/documentation-generator

# Create shared utilities directory
mkdir -p agents/shared

echo "Directory structure created successfully!"