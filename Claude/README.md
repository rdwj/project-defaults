# Claude Configuration Files

This directory contains standardized configuration files for Claude AI to ensure consistent development practices across all projects. These files codify our enterprise development standards, including Red Hat OpenShift focus, FastMCP patterns, and YAML-based prompt management.

## Files Overview

### 📄 `CLAUDE.md`
**For Claude Code (command-line tool)**
- Comprehensive development guidelines in markdown format
- Used by Claude Code for agentic coding assistance
- Covers architecture, technology choices, and coding standards

### 📄 `global_preferences.json` 
**For Claude Desktop/Web interface**
- Structured JSON preferences for interactive Claude sessions
- Referenced during conversations for consistent guidance
- Same standards as CLAUDE.md in JSON format

## Installation & Setup

### Claude Code Configuration

1. **Copy to your home directory:**
   ```bash
   cp CLAUDE.md ~/CLAUDE.md
   ```

2. **Or copy to specific project:**
   ```bash
   cp CLAUDE.md /path/to/your/project/CLAUDE.md
   ```

3. **Verify Claude Code can access it:**
   ```bash
   claude-code --help
   # Claude Code will automatically detect and use CLAUDE.md
   ```

### Claude Desktop Configuration

1. **Store globally for all projects:**
   ```bash
   # Create Claude config directory
   mkdir -p ~/.config/claude
   cp global_preferences.json ~/.config/claude/
   ```

2. **Or reference in specific conversations:**
   - Upload `global_preferences.json` to Claude desktop
   - Ask Claude to reference it for the session

## Usage Examples

### With Claude Code

```bash
# Claude Code automatically references CLAUDE.md when available
claude-code "Create a new FastMCP server for managing user profiles"

# Claude will follow the guidelines to:
# - Use FastAPI instead of Flask
# - Structure prompts in YAML files
# - Use Red Hat UBI base images
# - Follow the standard project structure
```

### With Claude Desktop

```
"Please reference my global_preferences.json file and help me set up a new Python project for document processing."

Claude will automatically:
- Suggest venv for environment management
- Recommend Docling for document processing
- Use the standard project structure
- Create Containerfile with UBI base image
```

## What These Files Enforce

### 🏗️ Architecture Standards
- **Containers**: Podman + Red Hat UBI images (never Docker)
- **MCP Servers**: FastMCP v2 with streamable-http transport
- **APIs**: FastAPI preferred, avoid gRPC unless requested
- **Deployment**: OpenShift with GitOps (ArgoCD) and Tekton pipelines

### 🐍 Python Development
- **Environment**: Always use venv, never global installs
- **Packages**: Search PyPI for current versions
- **Frameworks**: FastAPI > Flask, LangChain/LangGraph for AI
- **AI/ML**: vLLM-compatible models, Docling for documents

### 📁 Project Structure
```
project-root/
├── Containerfile          # Red Hat UBI base
├── podman-compose.yml     # Local orchestration  
├── manifests/             # OpenShift deployment
├── src/                   # Source code
├── prompts/              # YAML prompt management
├── mcp-servers/          # FastMCP servers
├── agents/               # AI agents
└── tests/                # Test suites
```

### 🎯 Prompt Management
- **Format**: YAML files in `prompts/` directory
- **Variables**: `{variable_name}` substitution format
- **Schemas**: Separate JSON files for structured responses
- **Rationale**: Keep prompts easily editable vs baking into code

### 🚀 MCP Publishing Strategy
- **Python Package**: pyproject.toml + internal PyPI
- **Containers**: Multi-stage builds + OpenShift registry
- **Deployment**: Kustomize overlays + ArgoCD
- **Developer Tools**: CLI tools + documentation + scaffolding

## Team Adoption

### For New Team Members

1. **Copy both files to your development environment**
2. **Install Claude Code and place CLAUDE.md appropriately**
3. **Upload global_preferences.json to Claude desktop for reference**
4. **Start using Claude with consistent enterprise standards**

### For Existing Projects

1. **Gradually adopt the standards during refactoring**
2. **Use the quick checklist in both files for validation**
3. **Reference during code reviews and architecture decisions**
4. **Share with other teams as enterprise standards**

## Key Benefits

### 🎯 Consistency
- All Claude interactions follow the same enterprise standards
- Reduces "reinventing the wheel" across teams
- Ensures Red Hat OpenShift compatibility from day one

### ⚡ Speed
- No need to explain preferences in every Claude conversation
- Claude provides relevant suggestions immediately
- Faster onboarding for new developers

### 🔒 Compliance
- Built-in FIPS compliance awareness
- Enterprise security practices by default
- OpenShift-native approaches prioritized

### 📈 Quality
- Enforces best practices for error handling
- Promotes maintainable code structure
- Encourages proper documentation and testing

## Maintenance

### Updating Standards

1. **Modify both files when standards change**
2. **Test changes with sample Claude interactions**
3. **Distribute updates to all team members**
4. **Update project templates accordingly**

### Version Control

```bash
# Track changes to standards
git add CLAUDE.md global_preferences.json README.md
git commit -m "Update Claude configs: deprecate SSE, add new MCP guidance"
git push origin main
```

## Troubleshooting

### Claude Code Not Using CLAUDE.md
- Ensure file is in project root or home directory
- Check file permissions (readable)
- Verify Claude Code installation

### Claude Desktop Not Following Preferences  
- Re-upload global_preferences.json if needed
- Explicitly reference the file in conversations
- Ask Claude to "follow my global preferences"

### Standards Conflicts
- These files represent current best practices
- Discuss conflicts with architecture team
- Update files when standards evolve

## Support

For questions about these configurations or enterprise development standards:
- Contact: Wes Jackson

---

**Last Updated**: 2025-08-03
**Version**: 1.0  
**Maintained by**: Wes Jackson