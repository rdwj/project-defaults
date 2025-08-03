# PROJECT_DEFAULTS

Enterprise development standards, templates, and configuration files for consistent software development practices across teams.

## 📁 Repository Contents

### 🤖 Claude AI Configuration (`/Claude`)
Standardized configuration files for Claude AI to ensure consistent development practices:
- **`CLAUDE.md`** - Comprehensive development guidelines for Claude Code (CLI tool)
- **`global_preferences.json`** - Structured preferences for Claude Desktop/Web interface
- **`README.md`** - Setup instructions and usage examples

### 💬 Chat Guide Templates (`/chat_guides`)
Structured markdown templates for breaking down complex software projects into manageable AI-assisted tasks:
- **`CHAT-GUIDE-TEMPLATE.md`** - Master template for creating new chat guides
- **`EXAMPLE-user-authentication.md`** - Example guide for implementing user authentication
- **`Example-ARCHITECTURE.md`** - Architecture documentation template following enterprise standards
- **`PROJECT-DEFAULTS.md`** - Core development standards reference
- **`README.md`** - Guide to using chat guides effectively

### 🖱️ Cursor Configuration (`/Cursor`)
- **`CURSOR-SETUP.md`** - Instructions for setting up global Cursor rules to match enterprise standards

### 🔌 MCP Server Examples (`/mcp_servers`)
Model Context Protocol server examples using FastMCP v2:
- **`prompt_management_mcp/`** - YAML-based prompt management system
  - `build_mcp_deployment.sh` - Build script for MCP deployment
  - `prompt_management_mcp.py` - Core MCP server implementation
  - `yaml-prompt-mcp/` - Full project structure with OpenShift deployment

## 🚀 Quick Start

### 1. Set Up Claude AI Standards
```bash
# For Claude Code (CLI)
cp Claude/CLAUDE.md ~/CLAUDE.md
# Or copy to your project root
cp Claude/CLAUDE.md /path/to/your/project/

# For Claude Desktop
# Upload Claude/global_preferences.json in your Claude session
```

### 2. Use Chat Guide Templates
```bash
# Copy template to your project
cp chat_guides/CHAT-GUIDE-TEMPLATE.md /path/to/project/01-feature-name.md
# Customize for your specific feature
```

### 3. Configure Cursor IDE
Follow the instructions in `Cursor/CURSOR-SETUP.md` to set up global rules.

### 4. Deploy MCP Servers
```bash
cd mcp_servers/prompt_management_mcp/yaml-prompt-mcp
./scripts/build.sh
./scripts/deploy-openshift.sh prod my-namespace
```

## 📋 Key Standards

### Container Platform
- **Runtime**: Podman (NOT Docker)
- **Files**: `Containerfile` (NOT Dockerfile)
- **Base Images**: Red Hat UBI (`registry.redhat.io/ubi9/*`)
- **Orchestration**: `podman-compose.yml`

### Python Development
- **Environment**: Always use `venv`
- **Framework**: FastAPI preferred over Flask
- **MCP**: FastMCP v2 with streamable-http transport
- **Package Versions**: Search PyPI for current versions

### Deployment
- **Target**: Red Hat OpenShift
- **GitOps**: ArgoCD
- **CI/CD**: OpenShift Pipelines (Tekton)
- **Monitoring**: OpenShift built-in

### AI/ML Stack
- **Agents**: LangChain/LangGraph
- **Models**: vLLM-compatible
- **Documents**: Docling
- **Prompts**: YAML format in `prompts/` directory

## 🏗️ Standard Project Structure

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

## 🔒 Security & Compliance

- **FIPS Compliance**: May be required - always ask
- **Authentication**: OAuth2/OIDC via OpenShift
- **Secrets**: OpenShift Secrets or HashiCorp Vault
- **Base Images**: FIPS-enabled UBI when needed

## 📚 Documentation

Each directory contains its own README with detailed information:
- [Claude Configuration Guide](Claude/README.md)
- [Chat Guides Tutorial](chat_guides/README.md)
- [Cursor Setup Instructions](Cursor/CURSOR-SETUP.md)

## 🤝 Contributing

1. Follow the standards defined in this repository
2. Test changes in your local environment
3. Update documentation as needed
4. Submit pull requests with clear descriptions

## 📧 Support

For questions about these standards or enterprise development practices:
- **Maintainer**: Wes Jackson
- **Last Updated**: 2025-08-03
- **Version**: 1.0

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Remember**: These standards ensure consistency, security, and maintainability across all enterprise projects. When in doubt, refer to the [PROJECT_DEFAULTS](chat_guides/PROJECT-DEFAULTS.md) document.