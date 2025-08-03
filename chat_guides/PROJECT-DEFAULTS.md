# Project Development Defaults & Standards

> **📌 PURPOSE**: This document defines default technology choices, architectural patterns, and deployment standards for new projects unless explicitly specified otherwise.

## Container Platform

### Local Development
- **Platform**: Podman (NOT Docker)
- **Container Files**: OCI-compliant `Containerfile` (NOT `Dockerfile`)
- **Compose**: `podman-compose.yml` for orchestration
- **Registry**: Use `registry.redhat.io` or `quay.io` for base images when possible
- **Python Environment**: ALWAYS use `venv` for local testing to avoid system package corruption

### Container Best Practices
- **Base Images**: ALWAYS use Red Hat Universal Base Images (UBI) when possible
- **Registry Priority**: 
  1. `registry.redhat.io/ubi9/*` (preferred)
  2. `quay.io` (for community images)
  3. Other registries only when necessary

```dockerfile
# Example Containerfile structure
FROM registry.redhat.io/ubi9/python-311:latest
# Always use Red Hat UBI for better security, support, and OpenShift compatibility
```

## Deployment Platform

### Primary Target: Red Hat OpenShift
- **Version**: Latest stable OpenShift 4.x
- **Deployment Method**: GitOps with ArgoCD (when appropriate)
- **Image Registry**: Internal OpenShift registry or Quay.io
- **Route Strategy**: Edge-terminated TLS by default

### OpenShift AI Integration
- **Model Serving**: Use OpenShift AI Model Serving where applicable
- **Data Science Pipelines**: Leverage OpenShift AI pipelines for ML workflows
- **Notebooks**: JupyterHub on OpenShift for development
- **Model Registry**: Integrate with OpenShift AI model registry

### Deployment Considerations
```yaml
# OpenShift-specific annotations
metadata:
  annotations:
    openshift.io/display-name: "Application Name"
    openshift.io/documentation-url: "https://docs.example.com"
```

## Architecture Principles

### 1. Loose Coupling
- **API-First Design**: All services expose well-defined APIs
- **MCP Integration**: Use Model Context Protocol servers for AI capabilities
- **Event-Driven**: Prefer async messaging over synchronous calls where appropriate
- **Service Mesh**: Consider OpenShift Service Mesh for complex microservices

### 2. API Design Standards
- **REST**: OpenAPI 3.0 specification required
  - **Framework**: FastAPI (preferred for Python projects)
  - **Real-time**: Use Server-Sent Events (SSE) for streaming in REST APIs
- **GraphQL**: Where complex queries benefit from it
- **gRPC**: Lower priority - often more trouble than it's worth
- **Versioning**: URL path versioning (e.g., `/api/v1/`)
- **MCP Real-time**: Use `streamable-http` for real-time communication in MCP servers

### 3. MCP Server Architecture
```python
# Preferred MCP implementation
from fastmcp import FastMCP

# Separate MCP servers for different domains
# - One for data operations
# - One for AI/ML operations
# - One for external integrations
```

### Package Version Management
- **NEVER hardcode versions from training data** - they're likely outdated
- **Always** either:
  1. Search PyPI for the latest version: `pip search <package>` or web search
  2. Let pip resolve versions: `pip install fastapi fastmcp`
  3. Use `pip install --upgrade` for existing packages

## AI/Agent Development

### Primary Frameworks
1. **LangChain/LangGraph** (Default for complex agents)
   - Use for multi-step reasoning
   - State machine implementations
   - Tool orchestration

2. **Meta LlamaStack** (General-purpose agent framework)
   - GitHub: https://github.com/meta-llama/llama-stack
   - Not limited to Llama models - supports various LLMs
   - Provides standardized agent interfaces
   - Built-in safety and evaluation features

### Agent Architecture Patterns
```python
# LangGraph state machine pattern
from langgraph.graph import StateGraph, State
from typing import TypedDict, List

class AgentState(TypedDict):
    messages: List[str]
    context: dict
    next_action: str

# Prefer explicit state management
# Use checkpointing for long-running workflows
```

### Model Selection
- **Local SLMs**: For sensitive data or offline requirements
- **OpenShift AI Models**: For enterprise deployments
- **Public Cloud Hosted**: Only for non-sensitive, general-purpose tasks (e.g., OpenAI, Anthropic, Google)

### Embedding Models
- **Requirement**: Must be compatible with vLLM for efficient serving
- **Recommended Models**:
  - **sentence-transformers/all-MiniLM-L6-v2**: Lightweight, general purpose
  - **BAAI/bge-base-en-v1.5**: High quality, balanced performance
  - **thenlper/gte-large**: Superior accuracy when quality matters
  - **e5-base-v2**: Multilingual support
- **Deployment**: Use vLLM for production serving of embedding models

### Document Processing
- **Text Extraction**: Docling (preferred for all document types)
  - Handles PDFs, DOCX, PPTX, images
  - Preserves document structure
  - Extracts tables and figures
- **Usage Pattern**:
```python
from docling import Document

# Standard pattern for document conversion
doc = Document.from_file("document.pdf")
text = doc.export_to_text()
markdown = doc.export_to_markdown()
```

## Security & Compliance

### FIPS Compliance (When Required)
- **Cryptography**: Use FIPS 140-2 validated modules
- **Base Images**: Use FIPS-enabled UBI images
- **Python**: `cryptography` library with FIPS backend
- **TLS**: Minimum TLS 1.2, prefer TLS 1.3

```dockerfile
# FIPS-compliant base image
FROM registry.redhat.io/ubi9/ubi:latest
RUN dnf install -y crypto-policies-scripts && \
    update-crypto-policies --set FIPS
```

### Security Defaults
- **Authentication**: OAuth2/OIDC via OpenShift
- **Authorization**: RBAC with OpenShift groups
- **Secrets**: OpenShift Secrets or HashiCorp Vault
- **Network Policies**: Deny-by-default, explicit allows

## Data Storage

### Databases
- **Relational**: PostgreSQL (OpenShift PostgreSQL Operator)
- **Document**: MongoDB (when schema flexibility needed)
- **Graph**: Neo4j (for relationship-heavy data)
- **Vector Databases**:
  - **PGVector**: PostgreSQL extension (when already using PostgreSQL)
  - **Milvus**: Purpose-built vector database for scale
  - **Weaviate**: When combining vector search with knowledge graphs
- **Cache**: Redis (OpenShift Redis Operator)

### Persistent Storage
- **Storage Class**: Use default OpenShift storage class
- **Volume Type**: RWO for databases, RWX for shared files
- **Backup**: Integrate with OADP (OpenShift API for Data Protection)

## Development Workflow

### Python Development
- **Virtual Environments**: ALWAYS use `venv` for local Python development
- **Environment Isolation**: Never install packages globally
- **Activation**: Source the venv before any Python operations

```bash
# Standard Python venv setup
python -m venv venv
source venv/bin/activate  # On Linux/Mac
# or
venv\Scripts\activate     # On Windows

# Install dependencies
pip install -r requirements.txt

# Deactivate when done
deactivate
```

### GitOps with ArgoCD
```yaml
# ArgoCD Application example
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: openshift-gitops
spec:
  project: default
  source:
    repoURL: https://git.example.com/my-app
    targetRevision: main
    path: manifests/
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### CI/CD Pipeline
- **Build**: OpenShift Pipelines (Tekton)
- **Image Scanning**: Red Hat Advanced Cluster Security
- **Deployment**: ArgoCD for GitOps
- **Monitoring**: OpenShift built-in monitoring + custom dashboards

## Monitoring & Observability

### OpenShift Native
- **Metrics**: Prometheus (built-in)
- **Logging**: OpenShift Logging (EFK stack)
- **Tracing**: OpenShift distributed tracing (Jaeger)
- **Dashboards**: Grafana or OpenShift console plugins

### Application Instrumentation
```python
# OpenTelemetry for Python apps
from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

# Auto-instrumentation where possible
```

## Project Structure

### Standard Layout
```
project-root/
├── Containerfile           # OCI-compliant container definition
├── podman-compose.yml     # Local development orchestration
├── manifests/             # OpenShift/K8s manifests
│   ├── base/             # Base configurations
│   └── overlays/         # Environment-specific overrides
├── .argo/                # ArgoCD configurations
├── src/                  # Application source code
├── mcp-servers/          # MCP server implementations
├── agents/               # LangGraph/LangChain agents
└── tests/                # Test suites
```

## Development Principles

### Avoid Early Optimization
- **Get it working first**: Focus on basic functionality before optimization
- **Iterate**: Working code > perfect architecture
- **Measure before optimizing**: Use actual metrics, not assumptions
- **YAGNI**: You Aren't Gonna Need It - avoid over-engineering

### No Mocking as Troubleshooting
- **NEVER mock functionality to bypass errors** - Fix the root cause
- **If something is broken, it should stay visibly broken** until fixed
- **Mocking is for intentional design**, not error workarounds
- **Exception**: Only mock when explicitly requested for demos or testing

```python
# ❌ BAD: Mocking to avoid fixing an error
try:
    result = broken_api_call()
except Exception:
    # Don't do this to make UI "work"
    result = {"fake": "data"}

# ✅ GOOD: Let errors surface
try:
    result = broken_api_call()
except Exception as e:
    logger.error(f"API call failed: {e}")
    raise  # Let the error propagate
```

## Technology Stack Checklist

When starting a new project, consider:

- [ ] OpenShift deployment requirements defined
- [ ] FIPS compliance needed? Enable from start
- [ ] OpenShift AI features identified and planned
- [ ] MCP server architecture designed
- [ ] Agent framework selected (LangGraph/LlamaStack)
- [ ] API contracts defined (OpenAPI/GraphQL schema)
- [ ] Persistent storage requirements identified
- [ ] Security model defined (RBAC, network policies)
- [ ] GitOps repository structure created
- [ ] Monitoring strategy planned
- [ ] Basic functionality working before optimization

## Quick Start Commands

```bash
# Create project structure
mkdir -p {src,manifests/{base,overlays},mcp-servers,agents,tests,.argo}

# Initialize podman-compose
cat > podman-compose.yml << 'EOF'
version: '3.8'
services:
  app:
    build:
      context: .
      file: Containerfile
    ports:
      - "8000:8000"
EOF

# Create base Containerfile
cat > Containerfile << 'EOF'
FROM registry.redhat.io/ubi9/python-311:latest
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "-m", "app"]
EOF
```

## References

- [OpenShift Documentation](https://docs.openshift.com/)
- [OpenShift AI Documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai/)
- [Podman Documentation](https://podman.io/docs)
- [LangGraph Documentation](https://python.langchain.com/docs/langgraph)
- [LlamaStack Repository](https://github.com/meta-llama/llama-stack)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [FIPS 140-2 Compliance](https://csrc.nist.gov/publications/detail/fips/140/2/final)

---

**Note**: These defaults can be overridden on a per-project basis. Always document deviations in the project's README or ARCHITECTURE.md file.