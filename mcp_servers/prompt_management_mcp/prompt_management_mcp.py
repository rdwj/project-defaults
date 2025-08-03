"""
MCP Server that catalogs prompts from YAML files
"""
import yaml
import os
from pathlib import Path
from typing import Dict, Any, List
from fastmcp import FastMCP, Context
from fastmcp.types import Message

class YAMLPromptManager:
    """Manages prompts stored in YAML files"""
    
    def __init__(self, prompts_dir: str = "prompts"):
        self.prompts_dir = Path(prompts_dir)
        self.prompts_cache = {}
        self.load_prompts()
    
    def load_prompts(self):
        """Load all YAML prompt files from the prompts directory"""
        if not self.prompts_dir.exists():
            print(f"Prompts directory {self.prompts_dir} does not exist")
            return
            
        for yaml_file in self.prompts_dir.glob("*.yaml"):
            try:
                with open(yaml_file, 'r', encoding='utf-8') as f:
                    prompt_data = yaml.safe_load(f)
                    
                # Use filename (without extension) as prompt key
                prompt_key = yaml_file.stem
                self.prompts_cache[prompt_key] = prompt_data
                print(f"Loaded prompt: {prompt_key}")
                
            except Exception as e:
                print(f"Error loading prompt from {yaml_file}: {e}")
    
    def get_prompt(self, prompt_name: str) -> Dict[str, Any]:
        """Get a specific prompt by name"""
        return self.prompts_cache.get(prompt_name)
    
    def list_prompts(self) -> List[str]:
        """List all available prompt names"""
        return list(self.prompts_cache.keys())
    
    def render_prompt(self, prompt_name: str, variables: Dict[str, Any] = None) -> str:
        """Render a prompt template with variables"""
        prompt = self.get_prompt(prompt_name)
        if not prompt:
            raise ValueError(f"Prompt '{prompt_name}' not found")
        
        template = prompt.get('template', '')
        if variables:
            # Simple variable substitution
            for var_name, var_value in variables.items():
                template = template.replace(f"{{{var_name}}}", str(var_value))
        
        return template

# Initialize the MCP server and prompt manager
mcp = FastMCP("YAML Prompt Server")
prompt_manager = YAMLPromptManager("prompts")

# Dynamically register all YAML prompts as MCP prompts
def register_yaml_prompts():
    """Register all YAML prompts as MCP prompts"""
    
    for prompt_name in prompt_manager.list_prompts():
        prompt_data = prompt_manager.get_prompt(prompt_name)
        
        # Extract prompt metadata
        description = prompt_data.get('description', f'Prompt from {prompt_name}.yaml')
        variables = prompt_data.get('variables', [])
        
        # Create a dynamic function for this prompt
        def create_prompt_function(name: str, desc: str, vars_list: List[Dict]):
            async def prompt_function(**kwargs) -> str:
                """Dynamically generated prompt function"""
                # Validate required variables
                required_vars = [v['name'] for v in vars_list if v.get('required', False)]
                missing_vars = [var for var in required_vars if var not in kwargs]
                if missing_vars:
                    raise ValueError(f"Missing required variables: {missing_vars}")
                
                # Render the prompt
                return prompt_manager.render_prompt(name, kwargs)
            
            # Set function metadata
            prompt_function.__name__ = f"prompt_{name}"
            prompt_function.__doc__ = desc
            
            # Create function signature dynamically based on variables
            import inspect
            params = []
            for var in vars_list:
                var_name = var['name']
                var_type = str  # Default to string, could be enhanced
                is_required = var.get('required', False)
                
                if is_required:
                    param = inspect.Parameter(var_name, inspect.Parameter.POSITIONAL_OR_KEYWORD, annotation=var_type)
                else:
                    param = inspect.Parameter(var_name, inspect.Parameter.POSITIONAL_OR_KEYWORD, 
                                            annotation=var_type, default=None)
                params.append(param)
            
            # Update function signature
            sig = inspect.Signature(params)
            prompt_function.__signature__ = sig
            
            return prompt_function
        
        # Create and register the prompt function
        prompt_func = create_prompt_function(prompt_name, description, variables)
        
        # Register with MCP using the prompt decorator
        mcp.prompt(prompt_func)
        print(f"Registered MCP prompt: {prompt_name}")

# Register all YAML prompts when the server starts
register_yaml_prompts()

@mcp.tool
def reload_prompts() -> str:
    """Reload prompts from YAML files"""
    global prompt_manager
    prompt_manager.load_prompts()
    return f"Reloaded {len(prompt_manager.list_prompts())} prompts"

@mcp.tool
def list_available_prompts() -> List[str]:
    """List all available prompts"""
    return prompt_manager.list_prompts()

@mcp.resource("prompts://list")
def get_prompts_list():
    """Get list of all available prompts with metadata"""
    prompts_info = []
    for prompt_name in prompt_manager.list_prompts():
        prompt_data = prompt_manager.get_prompt(prompt_name)
        prompts_info.append({
            "name": prompt_name,
            "description": prompt_data.get('description', ''),
            "variables": prompt_data.get('variables', [])
        })
    return prompts_info

@mcp.resource("prompts://{prompt_name}")
def get_prompt_details(prompt_name: str):
    """Get details for a specific prompt"""
    prompt_data = prompt_manager.get_prompt(prompt_name)
    if not prompt_data:
        raise ValueError(f"Prompt '{prompt_name}' not found")
    return prompt_data

@mcp.tool
async def preview_prompt(prompt_name: str, ctx: Context, **variables) -> str:
    """Preview a prompt with sample variables"""
    try:
        rendered = prompt_manager.render_prompt(prompt_name, variables)
        await ctx.info(f"Preview for prompt '{prompt_name}':")
        return rendered
    except Exception as e:
        await ctx.error(f"Error previewing prompt: {e}")
        return f"Error: {e}"

if __name__ == "__main__":
    mcp.run()