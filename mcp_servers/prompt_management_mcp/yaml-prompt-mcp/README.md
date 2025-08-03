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
