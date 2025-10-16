#!/usr/bin/env python3
"""
DevOps Hello World Application
A simple Python script demonstrating containerization and CI/CD
"""

import os
import sys
from datetime import datetime


def main():
    """
    Main function that prints a greeting message
    Supports custom messages via environment variable
    """
    # Get custom message from environment variable or use default
    message = os.environ.get('MESSAGE', 'Hello, DevOps!')
    
    # Print the message
    print(message)
    
    # Additional information for logging
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp}] Application executed successfully")
    
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
