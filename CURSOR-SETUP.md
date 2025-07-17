# Setting Up Global Cursor Rules

## Overview

Cursor allows you to define rules that guide AI assistants to follow your preferences and reduce token usage by avoiding repetitive explanations. You can set these rules at multiple levels:

1. **Global Rules**: Apply to all projects
2. **Project Rules**: Override global rules for specific projects
3. **Folder Rules**: Apply to specific directories

## Setting Up Global Rules

### Option 1: Cursor Settings (Recommended)

1. Open Cursor
2. Go to **Cursor Settings** (Cmd+, on Mac, Ctrl+, on Windows/Linux)
3. Navigate to **Cursor Settings > General > Rules for AI**
4. Copy the contents of `.cursorrules` into the text area
5. These rules will now apply to all your projects

### Option 2: Global Config File

Cursor looks for rules in these locations (in order):
1. `.cursorrules` in the current directory
2. `.cursorrules` in parent directories
3. Global cursor config directory

To set up a global config:
```bash
# On macOS/Linux
mkdir -p ~/.config/cursor
cp /Users/wjackson/Developer/PROJECT_DEFAULTS/.cursorrules ~/.config/cursor/rules

# On Windows
# Copy to %APPDATA%\Cursor\rules
```

## Using Project-Specific Rules

For projects that need different settings:

1. Copy the global `.cursorrules` to your project root
2. Modify as needed for that specific project
3. The project rules will override global rules

```bash
# Example: Project needs Docker instead of Podman
cp /Users/wjackson/Developer/PROJECT_DEFAULTS/.cursorrules ./
# Edit .cursorrules to change Podman references to Docker
```

## Benefits of Using Cursor Rules

### 1. **Reduced Token Usage**
- AI doesn't need to ask about your preferences
- Avoids suggesting Docker when you use Podman
- Knows to use FastAPI without being told

### 2. **Consistent Behavior**
- Same architectural patterns across projects
- Consistent error handling (no mocking workarounds)
- Standard project structure

### 3. **Faster Development**
- AI immediately knows your tech stack
- No need to explain FIPS requirements repeatedly
- Automatic use of preferred libraries

## Rule Categories in Our Setup

### Environment Rules
- Container platform preferences
- Python virtual environment requirements
- Package management approach

### Architecture Rules
- API design preferences
- Database selections
- Deployment targets

### Development Practice Rules
- Error handling philosophy
- Testing approaches
- Documentation standards

## Tips for Effective Rules

1. **Be Specific**: "Use FastAPI" is better than "use a modern web framework"
2. **Include Examples**: Show preferred patterns in code blocks
3. **Explain Why**: Brief reasons help AI make better decisions
4. **Update Regularly**: Add new preferences as you discover them

## Monitoring Rule Effectiveness

You'll know rules are working when:
- AI suggests Podman commands without being asked
- Virtual environments are always recommended
- FastAPI is the default choice for new APIs
- Errors aren't masked with mock data

## Updating Rules

When you discover new patterns:
1. Add them to `/Users/wjackson/Developer/PROJECT_DEFAULTS/.cursorrules`
2. Update your global Cursor settings
3. Commit the changes for team sharing

## Sharing with Teams

```bash
# Share rules with your team
git add .cursorrules
git commit -m "Add team coding standards for Cursor AI"
git push
```

Team members can then:
1. Copy `.cursorrules` to their projects
2. Or set up as global rules in their Cursor settings

## Troubleshooting

**Rules not being applied?**
- Check file is named exactly `.cursorrules`
- Verify it's in the project root
- Restart Cursor after adding global rules
- Check for syntax errors in the rules file

**Conflicting suggestions?**
- Project rules override global rules
- More specific rules override general ones
- Recent context can override rules (this is normal)

## Example Rule Impact

Without rules:
```
AI: "Let's create a Dockerfile for your Python app..."
You: "I use Podman and Containerfile"
AI: "Okay, here's a Containerfile..."
```

With rules:
```
AI: "I'll create a Containerfile using the Red Hat UBI Python image..."
```

This saves tokens and time on every interaction!