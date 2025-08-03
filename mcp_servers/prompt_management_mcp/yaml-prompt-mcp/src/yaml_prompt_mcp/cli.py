#!/usr/bin/env python3
"""CLI for running YAML Prompt MCP servers"""
import argparse
import sys
from pathlib import Path
from .server import create_prompt_server

def main():
    parser = argparse.ArgumentParser(description="YAML Prompt MCP Server")
    parser.add_argument("--prompts-dir", default="prompts", 
                       help="Directory containing YAML prompt files")
    parser.add_argument("--name", default="YAML Prompt Server",
                       help="Server name")
    parser.add_argument("--transport", choices=["stdio", "http", "sse"], 
                       default="stdio", help="Transport protocol")
    parser.add_argument("--host", default="0.0.0.0", help="Host for HTTP/SSE")
    parser.add_argument("--port", type=int, default=8000, help="Port for HTTP/SSE")
    
    args = parser.parse_args()
    
    if not Path(args.prompts_dir).exists():
        print(f"Error: Prompts directory '{args.prompts_dir}' does not exist")
        sys.exit(1)
    
    server = create_prompt_server(args.name, args.prompts_dir)
    
    if args.transport == "stdio":
        server.run()
    elif args.transport == "http":
        server.run(transport="http", host=args.host, port=args.port)
    elif args.transport == "sse":
        server.run(transport="sse", host=args.host, port=args.port)

if __name__ == "__main__":
    main()
