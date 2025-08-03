# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a PROJECT_DEFAULTS repository containing enterprise development standards and templates for:
- Claude AI configuration files (global preferences for Claude Code and Desktop)
- Chat guide templates for managing complex software projects
- MCP server examples using FastMCP v2
- Development best practices following Red Hat OpenShift standards

## Common Development Commands

### Python Development
```bash
# Always create and activate a virtual environment first
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies (search PyPI for current versions)
pip install -r requirements.txt

# Build Python packages
python -m build
```

### Container Operations
```bash
# Build container images (using Podman, not Docker)
podman build -t <image-name>:latest -f Containerfile .

# Run containers locally
podman-compose up -d

# Deploy to OpenShift
./scripts/deploy-openshift.sh <environment> <namespace>
```

### MCP Server Commands
```bash
# Run MCP server with STDIO transport (default)
yaml-prompt-mcp --prompts-dir ./prompts

# Run with HTTP transport for production
yaml-prompt-mcp --transport http --host 0.0.0.0 --port 8000
```

## High-Level Architecture

### Technology Stack Requirements
- **Container Runtime**: Podman (NOT Docker)
- **Container Files**: Use `Containerfile` (NOT Dockerfile)
- **Base Images**: Red Hat UBI (`registry.redhat.io/ubi9/*`)
- **Python Framework**: FastAPI preferred over Flask
- **MCP Implementation**: FastMCP v2 with streamable-http transport
- **Deployment Target**: Red Hat OpenShift

### Project Structure Pattern
```
project-root/
├── Containerfile          # Red Hat UBI base
├── podman-compose.yml     # Local orchestration  
├── manifests/             # OpenShift deployment
│   ├── base/
│   └── overlays/
├── src/                   # Source code
├── prompts/              # YAML prompt management
├── mcp-servers/          # FastMCP servers
├── agents/               # AI agents
└── tests/                # Test suites
```

### Key Architectural Decisions

1. **Prompt Management**: YAML files in `prompts/` directory for easy editing and version control
2. **MCP Publishing Strategy**: Multi-layered approach with Python packages, containers, and OpenShift manifests
3. **Security**: FIPS compliance awareness, OAuth2/OIDC via OpenShift
4. **AI/ML Stack**: LangChain/LangGraph for agents, vLLM-compatible models, Docling for documents
5. **Database Choices**: PostgreSQL (relational), MongoDB (document), Redis (cache), Milvus/Weaviate (vector)

### Development Practices

- **NEVER mock functionality** to work around errors - let broken things stay visibly broken
- **Always use venv** for Python development, never install packages globally
- **Search PyPI** for current package versions rather than using potentially outdated information
- **Create directories with scripts** rather than manually creating structures
- **Use streamable-http** for MCP servers (SSE is deprecated)

## Critical Implementation Notes

1. **Claude AI Configuration**: This repo contains standardized configs that should be referenced when setting up new projects
2. **Chat Guides**: Templates for breaking down complex projects into manageable AI-assisted tasks
3. **MCP Servers**: Example implementations use FastMCP v2 with YAML-based prompt management
4. **OpenShift Deployment**: All examples include Kustomize-based manifests for GitOps deployment