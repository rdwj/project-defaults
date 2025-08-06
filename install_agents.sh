#!/bin/bash

# Install Claude Code agents to user-scoped directory
# These will be available across all projects

SOURCE_DIR="/Users/wjackson/Developer/PROJECT_DEFAULTS/agents"
TARGET_DIR="$HOME/.claude/agents"

echo "Installing Claude Code agents to user directory..."
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy all agent directories
for agent_dir in "$SOURCE_DIR"/*/; do
    if [ -d "$agent_dir" ]; then
        agent_name=$(basename "$agent_dir")
        echo "Installing agent: $agent_name"
        
        # Create agent directory in target
        mkdir -p "$TARGET_DIR/$agent_name"
        
        # Copy all files from agent directory
        cp -r "$agent_dir"* "$TARGET_DIR/$agent_name/"
    fi
done

# Copy the MODEL-SELECTION-GUIDE.md
if [ -f "$SOURCE_DIR/MODEL-SELECTION-GUIDE.md" ]; then
    echo "Copying MODEL-SELECTION-GUIDE.md"
    cp "$SOURCE_DIR/MODEL-SELECTION-GUIDE.md" "$TARGET_DIR/"
fi

# Copy the main README.md
if [ -f "$SOURCE_DIR/README.md" ]; then
    echo "Copying main README.md"
    cp "$SOURCE_DIR/README.md" "$TARGET_DIR/"
fi

echo ""
echo "Installation complete!"
echo "Agents installed to: $TARGET_DIR"
echo ""
echo "Available agents:"
ls -1 "$TARGET_DIR" | grep -v '.md' | sed 's/^/  - /'
echo ""
echo "These agents are now available globally in all Claude Code sessions."
echo "Use them with the /agents command in Claude Code."