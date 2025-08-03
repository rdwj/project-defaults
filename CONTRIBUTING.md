# Contributing to PROJECT_DEFAULTS

Thank you for your interest in contributing to our enterprise development standards! This guide will help you understand how to effectively contribute to this repository.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Process](#development-process)
- [Style Guidelines](#style-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Standards Evolution](#standards-evolution)

## 🤝 Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on what is best for the enterprise and development teams
- Show empathy towards other community members
- Accept constructive criticism gracefully

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks or trolling
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate in a professional setting

## 🎯 How Can I Contribute?

### Reporting Issues

Before creating an issue, please check if it already exists. When creating a new issue, include:

- Clear, descriptive title
- Detailed description of the issue
- Steps to reproduce (if applicable)
- Expected vs actual behavior
- Your environment details
- Possible solutions or workarounds you've tried

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When suggesting an enhancement:

- Use a clear and descriptive title
- Provide a detailed description of the proposed enhancement
- Explain why this enhancement would be useful to most users
- List any alternative solutions or features you've considered
- Include examples of how the enhancement would be used

### Contributing Standards

We welcome contributions in these areas:

1. **New Templates**: Chat guides, architecture documents, configuration examples
2. **Standard Updates**: Improvements to existing standards based on team experiences
3. **Documentation**: Clarifications, examples, troubleshooting guides
4. **Tool Configurations**: New MCP servers, deployment scripts, automation tools
5. **Best Practices**: Security improvements, performance optimizations, workflow enhancements

## 🔄 Development Process

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR-USERNAME/PROJECT_DEFAULTS.git
cd PROJECT_DEFAULTS
git remote add upstream https://github.com/ORIGINAL-OWNER/PROJECT_DEFAULTS.git
```

### 2. Create a Branch

```bash
# Create a descriptive branch name
git checkout -b feature/add-kubernetes-chat-guide
# or
git checkout -b update/fastapi-security-standards
# or
git checkout -b fix/mcp-server-deployment-script
```

### 3. Make Your Changes

Follow these guidelines:

- **Test your changes** in a real project environment
- **Update documentation** to reflect any changes
- **Follow existing patterns** in the repository
- **Validate configurations** work as expected
- **Consider backward compatibility** when updating standards

### 4. Test Your Changes

For different types of contributions:

#### Configuration Files
```bash
# Test Claude configurations
cp Claude/CLAUDE.md ~/test-project/
# Verify Claude Code recognizes and uses the configuration

# Test MCP servers
cd mcp_servers/prompt_management_mcp
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python prompt_management_mcp.py
```

#### Chat Guides
- Create a test project using your new guide
- Verify all checkboxes can be completed
- Ensure instructions are clear and accurate
- Test with an AI assistant to ensure it works as intended

#### Container Configurations
```bash
# Test Containerfiles build successfully
podman build -t test-image -f Containerfile .

# Verify podman-compose configurations
podman-compose up -d
podman-compose down
```

### 5. Commit Your Changes

See [Commit Messages](#commit-messages) section for guidelines.

## 📝 Style Guidelines

### Markdown Files

- Use clear, concise language
- Include code examples where helpful
- Use proper heading hierarchy (# > ## > ###)
- Add table of contents for long documents
- Use emoji sparingly and consistently

### Code and Scripts

- Follow PEP 8 for Python code
- Use shellcheck for bash scripts
- Include error handling and validation
- Add comments for complex logic
- Use meaningful variable names

### YAML Files

- Use 2-space indentation
- Include comments for non-obvious configurations
- Group related settings together
- Validate YAML syntax before committing

### Directory Structure

- Keep related files together
- Use descriptive directory names
- Include README.md in each major directory
- Follow the established project structure pattern

## 💬 Commit Messages

Follow the conventional commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature or standard
- **fix**: Bug fix or correction
- **docs**: Documentation changes
- **style**: Formatting, missing semicolons, etc.
- **refactor**: Code restructuring without changing functionality
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```bash
feat(claude): add support for claude-3-opus model configuration

docs(chat-guides): add troubleshooting section to template

fix(mcp): correct port configuration in deployment script

refactor(structure): reorganize MCP server examples for clarity
```

## 🚀 Pull Request Process

### Before Submitting

1. **Update documentation** - Ensure all docs reflect your changes
2. **Test thoroughly** - Verify changes work in real environments
3. **Check for conflicts** - Rebase on latest main branch
4. **Run linters** - Ensure code quality standards are met
5. **Update CHANGELOG** - Add entry for significant changes

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] New feature/standard
- [ ] Bug fix
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Testing
- [ ] Tested in local environment
- [ ] Tested in OpenShift cluster
- [ ] Documentation reviewed
- [ ] Examples validated

## Checklist
- [ ] My code follows the project style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] All new and existing tests pass
```

### Review Process

1. **Automated checks** run on all PRs
2. **Maintainer review** for alignment with enterprise standards
3. **Testing verification** in representative environment
4. **Documentation review** for completeness
5. **Final approval** and merge

## 🔄 Standards Evolution

### Proposing Major Changes

For significant changes to standards:

1. **Open an RFC issue** describing the proposed change
2. **Include rationale** and impact analysis
3. **Provide migration path** for existing projects
4. **Allow community discussion** (minimum 1 week)
5. **Update after feedback** incorporation
6. **Submit PR** with RFC reference

### Deprecation Process

When deprecating standards:

1. **Mark as deprecated** in documentation
2. **Provide timeline** for removal (minimum 3 months)
3. **Include migration guide** to new approach
4. **Update examples** to use new patterns
5. **Communicate changes** to affected teams

## 🎯 Areas Needing Contributions

Current priorities for contributions:

- Additional chat guide templates for common scenarios
- OpenShift 4.15+ specific configurations
- Advanced MCP server examples
- Security hardening guidelines
- Performance optimization patterns
- Multi-cloud deployment strategies
- AI/ML pipeline templates

## 📚 Resources

- [Red Hat OpenShift Documentation](https://docs.openshift.com/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [FastMCP Documentation](https://github.com/jlowin/fastmcp)
- [Podman Documentation](https://docs.podman.io/)

## 🙏 Recognition

Contributors will be recognized in:
- Release notes
- Contributors file
- Project documentation

Thank you for helping improve our enterprise development standards!

---

**Questions?** Contact the maintainers or open a discussion issue.