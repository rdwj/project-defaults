"""YAML-based prompt management for FastMCP servers"""
from .manager import YAMLPromptManager
from .server import create_prompt_server
from .cli import main

__version__ = "1.0.0"
__all__ = ["YAMLPromptManager", "create_prompt_server", "main"]
