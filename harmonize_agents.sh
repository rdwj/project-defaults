#!/bin/bash

# Script to harmonize agent formats between PROJECT_DEFAULTS and personal .claude/agents

echo "Harmonizing agent formats between project and personal directories..."

# Function to add model and color to frontmatter
update_agent_file() {
    local file="$1"
    local model="$2"
    local color="$3"
    local agent_name=$(basename "$file" .md)
    
    echo "Processing $agent_name in $(dirname "$file")..."
    
    # Check if file already has model field
    if grep -q "^model:" "$file"; then
        echo "  - Already has model field, skipping"
        return
    fi
    
    # Create temp file with updated frontmatter
    temp_file=$(mktemp)
    
    # Process the file - add fields right after 'tools:' or before closing '---'
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
    /^tools:/ && in_frontmatter == 1 && added_fields == 0 {
        print
        print "model: " model
        print "color: " color
        added_fields = 1
        next
    }
    in_frontmatter < 2 { print }
    ' "$file" > "$temp_file"
    
    # Replace original file
    mv "$temp_file" "$file"
    echo "  - Updated with model: $model, color: $color"
}

# Define agent configurations
declare -A agent_models
declare -A agent_colors

# Complex agents (Opus)
agent_models[mcp-generator]="opus"
agent_colors[mcp-generator]="blue"

agent_models[architecture-designer]="opus"
agent_colors[architecture-designer]="purple"

agent_models[neo4j-schema-designer]="opus"
agent_colors[neo4j-schema-designer]="cyan"

agent_models[microservices-architect]="opus"
agent_colors[microservices-architect]="magenta"

agent_models[langgraph-agent-builder]="opus"
agent_colors[langgraph-agent-builder]="blue"

agent_models[react-ui-designer]="opus"
agent_colors[react-ui-designer]="green"

# Moderate agents (Sonnet)
agent_models[openshift-deployer]="sonnet"
agent_colors[openshift-deployer]="red"

agent_models[granite-prompt-engineer]="sonnet"
agent_colors[granite-prompt-engineer]="yellow"

agent_models[llama-prompt-engineer]="sonnet"
agent_colors[llama-prompt-engineer]="yellow"

agent_models[gitops-engineer]="sonnet"
agent_colors[gitops-engineer]="orange"

agent_models[documentation-generator]="sonnet"
agent_colors[documentation-generator]="gray"

agent_models[security-scanner]="sonnet"
agent_colors[security-scanner]="red"

agent_models[test-runner]="sonnet"
agent_colors[test-runner]="green"

agent_models[streamlit-ui-designer]="sonnet"
agent_colors[streamlit-ui-designer]="blue"

# Simple agents (Haiku)
agent_models[code-reviewer]="haiku"
agent_colors[code-reviewer]="yellow"

agent_models[dependency-analyzer]="haiku"
agent_colors[dependency-analyzer]="cyan"

# Update both locations
echo "=== Updating PROJECT_DEFAULTS agents ==="
for agent_file in /Users/wjackson/Developer/PROJECT_DEFAULTS/agents/*.md; do
    if [[ -f "$agent_file" ]]; then
        agent_name=$(basename "$agent_file" .md)
        
        # Skip files that aren't agent definitions
        if [[ "$agent_name" == "README" ]] || [[ "$agent_name" == "MODEL-SELECTION-GUIDE" ]]; then
            continue
        fi
        
        # Get model and color for this agent
        model="${agent_models[$agent_name]}"
        color="${agent_colors[$agent_name]}"
        
        if [[ -n "$model" ]] && [[ -n "$color" ]]; then
            update_agent_file "$agent_file" "$model" "$color"
        else
            echo "Skipping $agent_name - no configuration found"
        fi
    fi
done

echo ""
echo "=== Updating personal .claude/agents ==="
for agent_file in /Users/wjackson/.claude/agents/*.md; do
    if [[ -f "$agent_file" ]]; then
        agent_name=$(basename "$agent_file" .md)
        
        # Skip files that aren't agent definitions
        if [[ "$agent_name" == "README" ]] || [[ "$agent_name" == "MODEL-SELECTION-GUIDE" ]]; then
            continue
        fi
        
        # Skip react-native-ux-designer as it already has the correct format
        if [[ "$agent_name" == "react-native-ux-designer" ]]; then
            echo "Skipping $agent_name - already properly formatted"
            continue
        fi
        
        # Get model and color for this agent
        model="${agent_models[$agent_name]}"
        color="${agent_colors[$agent_name]}"
        
        if [[ -n "$model" ]] && [[ -n "$color" ]]; then
            update_agent_file "$agent_file" "$model" "$color"
        else
            echo "Skipping $agent_name - no configuration found"
        fi
    fi
done

echo ""
echo "Harmonization complete!"
echo ""
echo "Summary:"
echo "- Complex agents (Opus): mcp-generator, architecture-designer, neo4j-schema-designer,"
echo "                        microservices-architect, langgraph-agent-builder, react-ui-designer"
echo "- Moderate agents (Sonnet): Most others including deployers, prompt engineers, test runners"
echo "- Simple agents (Haiku): code-reviewer, dependency-analyzer"