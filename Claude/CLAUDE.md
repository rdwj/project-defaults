# Global Development Preferences for Claude Code

This document defines the standard development practices, architecture decisions, and technical preferences for all projects. Always reference these guidelines when providing code examples, architecture suggestions, or project setup guidance.

## Environment & Platform Standards

### Container Runtime
- **ALWAYS use Podman**, NOT Docker
- Use `Containerfile`, NOT `Dockerfile`  
- Use `podman-compose.yml` for local orchestration
- Target deployment: Red Hat OpenShift with OpenShift AI features
- **Base Images**: Always use Red Hat UBI base images (`registry.redhat.io/ubi9/*`)
- **Platform Architecture**: When building on Mac for OpenShift deployment, always specify `--platform linux/amd64` to avoid ARM64/x86_64 architecture mismatches
  ```bash
  podman build --platform linux/amd64 -t myapp:latest -f Containerfile . --no-cache
  ```
- **Build Strategy**: Prefer using OpenShift BuildConfig over building and pushing containers locally where possible

### Security & Compliance
- FIPS compliance may be required - **always ask if unclear**
- Use FIPS-enabled UBI images when needed
- Authentication: OAuth2/OIDC via OpenShift
- Secrets: OpenShift Secrets or HashiCorp Vault

## Python Development Standards

### Environment Management
- **ALWAYS use venv** for local development
- **Never install packages globally**
- For package versions: **search PyPI or let pip resolve** (don't use training data versions)
- **Preferred web framework**: FastAPI (preferred over Flask for new projects)
- **MCP implementation**: FastMCP v2

### Development Practices
- **NEVER mock functionality** to work around errors
- **Let broken things stay visibly broken**
- Only mock when explicitly requested
- Focus on working code over perfect architecture
- Create explicit error messages that help debugging

## Architecture Principles

### API Design
- Prefer loose coupling via APIs
- Use MCP servers for AI capabilities
- **Real-time protocols**:
  - MCP: streamable-http (SSE is deprecated)
  - REST APIs: SSE for real-time updates, standard HTTP otherwise
- **Avoid gRPC** unless specifically requested
- **No early optimization** - get basic functionality working first

### MCP Server Transport Protocols

**For MCP Servers (FastMCP):**
- **STDIO (Default)**: Best for local tools and command-line scripts
- **HTTP (streamable-http)**: Recommended for web deployments and production (SSE is deprecated)

**For Regular APIs:**
- Standard HTTP/REST for web services
- Avoid gRPC unless specifically requested

## AI/ML Technology Stack

### Frameworks & Models
- **Agent frameworks**: LangChain/LangGraph or Meta LlamaStack
- **Embedding models**: Must be vLLM-compatible
- **Document processing**: Use Docling
- **Model deployment**:
  - Local SLMs for sensitive data
  - OpenShift AI Models for enterprise
  - Public Cloud Hosted only for non-sensitive tasks and with explicit approval

### Development Platform
- **Data flows**: KubeFlow pipelines for data flows and model development
- **Experimentation**: OpenShift AI workbenches

## Database Technology Choices

- **Relational**: PostgreSQL
- **Document**: MongoDB
- **Graph**: Neo4j
- **Vector**: PGVector (if using PostgreSQL), Milvus, or Weaviate
- **Cache**: Redis

## Standard Project Structure

Always create projects with this structure:

```
project-root/
├── Containerfile
├── podman-compose.yml
├── manifests/
│   ├── base/
│   └── overlays/
├── src/
├── prompts/                    # YAML-based prompt management
├── mcp-servers/
├── agents/
└── tests/
```

### Directory Creation
- **Always create a shell script** for directory creation and then run the script
- Don't manually create directory structures

## Prompt Management Standards

### Format & Organization
- **Format**: YAML files for easy editing and developer briefing
- **Directory**: `prompts/` (peer with `src/`)
- **Variable substitution**: Use `{variable_name}` format in templates
- **Response schemas**: Maintain separate JSON schema files when structured output is needed
- **Rationale**: Keep prompts easily editable rather than baking into MCP servers
- **Developer onboarding**: YAML format makes it easy to brief other developers on prompt functionality

### YAML Structure Requirements
```yaml
name: "Human-readable prompt name"
description: "Purpose and context of the prompt"
template: |
  Prompt text with {variable_name} substitution

# Optional fields:
parameters:
  - temperature: 0.0
  - max_tokens: 2000

variables:
  - name: "variable_name"
    type: "string"
    description: "Variable description"
    required: true
```

## Testing Standards

### Python Testing
- **Framework**: pytest for all Python testing
- **Coverage**: Aim for 80%+ code coverage minimum
- **Test Structure**: Mirror source code structure in `tests/` directory
- **Error Paths**: Explicitly test error conditions and edge cases
- **Fixtures**: Use pytest fixtures for reusable test setup
- **Mocking**: Mock external dependencies, not to hide errors

### Testing Practices
- Write tests before or alongside code (TDD/BDD when appropriate)
- Test both happy paths and failure scenarios
- Include integration tests for API endpoints
- Use descriptive test names that explain what is being tested
- Run tests locally before committing
- Include test commands in project documentation

### Test Execution
```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html

# Run specific test file
pytest tests/test_specific.py

# Run tests matching pattern
pytest -k "test_authentication"
```

## Deployment Standards

### CI/CD Pipeline
- **GitOps**: ArgoCD when appropriate
- **CI/CD**: OpenShift Pipelines (Tekton)
- **Monitoring**: OpenShift built-in monitoring

## MCP Server Publishing Strategy

When creating reusable MCP servers, use this multi-layered approach:

### 1. Python Package Distribution
- Use `pyproject.toml` with proper entry points for CLI tools
- Publish to internal PyPI for easy pip install across teams
- Provide template repositories for teams to clone and customize

### 2. Container Strategy
- Red Hat UBI for all container builds
- Use multi-stage builds for production optimization
- Push to OpenShift internal registry or enterprise container registry

### 3. OpenShift Deployment
- Provide base manifests with Kustomize overlays for different environments
- Structure for ArgoCD deployment
- Include ServiceMonitor for OpenShift monitoring stack

### 4. Developer Experience
- Provide command-line tools for easy server creation and management
- Include examples, API docs, and deployment guides
- Scripts to generate new MCP server projects with prompts

## Quick Reference Checklist

Before starting any project:

- [ ] Check if FIPS compliance is needed
- [ ] Set up venv before any Python work
- [ ] Search for latest package versions (don't use training data)
- [ ] Confirm Red Hat UBI base images only
- [ ] Choose FastAPI over Flask for new projects
- [ ] Use Docling for document processing
- [ ] Ensure embedding models are vLLM-compatible
- [ ] Use streamable-http for MCP servers (SSE is deprecated)
- [ ] Create directory structure with shell script
- [ ] Use `--platform linux/amd64` when building containers on Mac for OpenShift

## Code Generation Guidelines

### Architecture Awareness
- **If there is an ARCHITECTURE.md file** in the root, refer to it when writing new code and do not stray from it without discussion
- **Avoid creating multiple versions** of the same file as we iterate - edit files in place
- If introducing breaking changes, ask if backward compatibility is needed
- Without backward compatibility requirements, replace existing functionality directly

### File Organization
- **Aim for no more than 512 lines** in each code file to decrease context saturation
- If more than 512 lines are needed, consider breaking functions into importable utilities
- Do not simply truncate files - if slightly over 512 lines with nothing to break out, continue

### Git Operations
- **Never perform `git add` or `git commit` operations** - these are handled manually by the user
- Version control operations remain under user control

### When providing code examples:
1. **Always reference these preferences** for technology choices
2. **Search for current versions** rather than using potentially outdated information
3. **Ask about FIPS requirements** and security constraints for enterprise environments
4. **Prioritize Red Hat ecosystem** solutions and OpenShift-native approaches
5. **Focus on working solutions** that follow these standards rather than theoretical perfection
6. **For MCP server distribution**, recommend the multi-layered approach with Python packages, containers, and OpenShift manifests

### Error Handling Approach
- Never hide errors or mock functionality to work around problems
- Make failures obvious and debuggable
- Provide clear error messages that help developers understand what went wrong
- Only use mocking when explicitly requested by the developer

### MCP Server Development
- Default to STDIO transport for local development
- Use HTTP (streamable-http) transport for production deployments
- Structure prompts in YAML files within `prompts/` directory
- Implement proper variable substitution and validation
- Include reload capabilities for prompt management

## Communication & Collaboration

### Interaction Style
- **Direct responses preferred** - answer questions without assuming disagreement
- When asked for explanations, provide them within the overall application context
- If you disagree with an approach, be plain and direct
- Questions often seek understanding, not disagreement

## Enterprise Integration Notes

- Always consider security and compliance requirements
- Assume enterprise environment unless told otherwise
- Ask about existing infrastructure and integration points
- Consider scalability and monitoring from the start
- Plan for team collaboration and knowledge sharing
- Ensure all solutions work within Red Hat OpenShift ecosystem
- Design for multi-team usage and shared services where appropriate