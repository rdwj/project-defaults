#!/bin/bash

# Script to update agent markdown files with model and color fields

echo "Updating agent markdown files with model and color fields..."

# Function to add model and color to frontmatter
update_agent_file() {
    local file="$1"
    local model="$2"
    local color="$3"
    local agent_name=$(basename "$file" .md)
    
    echo "Processing $agent_name..."
    
    # Check if file already has model field
    if grep -q "^model:" "$file"; then
        echo "  - Already has model field, skipping"
        return
    fi
    
    # Create temp file with updated frontmatter
    temp_file=$(mktemp)
    
    # Process the file
    awk -v model="$model" -v color="$color" '
    BEGIN { in_frontmatter = 0; added_fields = 0 }
    /^---$/ { 
        if (in_frontmatter == 0) {
            in_frontmatter = 1
            print
        } else if (in_frontmatter == 1 && added_fields == 0) {
            # Add model and color before closing frontmatter
            print "model: " model
            print "color: " color
            print "---"
            in_frontmatter = 2
            added_fields = 1
        } else {
            print
        }
        next
    }
    in_frontmatter < 2 { print }
    ' "$file" > "$temp_file"
    
    # Replace original file
    mv "$temp_file" "$file"
    echo "  - Updated with model: $model, color: $color"
}

# Complex agents (Opus 4)
update_agent_file "agents/mcp-generator.md" "opus" "blue"
update_agent_file "agents/architecture-designer.md" "opus" "purple"
update_agent_file "agents/neo4j-schema-designer.md" "opus" "cyan"
update_agent_file "agents/microservices-architect.md" "opus" "magenta"
update_agent_file "agents/langgraph-agent-builder.md" "opus" "blue"
update_agent_file "agents/react-ui-designer.md" "opus" "green"

# Moderate agents (Sonnet)
update_agent_file "agents/openshift-deployer.md" "sonnet" "red"
update_agent_file "agents/granite-prompt-engineer.md" "sonnet" "yellow"
update_agent_file "agents/llama-prompt-engineer.md" "sonnet" "yellow"
update_agent_file "agents/gitops-engineer.md" "sonnet" "orange"
update_agent_file "agents/documentation-generator.md" "sonnet" "gray"
update_agent_file "agents/security-scanner.md" "sonnet" "red"
update_agent_file "agents/test-runner.md" "sonnet" "green"
update_agent_file "agents/streamlit-ui-designer.md" "sonnet" "blue"

# Simple agents (Haiku)
update_agent_file "agents/code-reviewer.md" "haiku" "yellow"
update_agent_file "agents/dependency-analyzer.md" "haiku" "cyan"

echo "All agent files updated!"