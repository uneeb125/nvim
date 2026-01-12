;; python
#!/usr/bin/env python3
# Created by {{_author_}} on {{_date_}}
"""{{_file_name_}} - CLI application."""

import argparse
import sys
from typing import Any


def parse_args() -> argparse.Namespace:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="{{_file_name_}} - CLI tool",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Enable verbose output",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        help="Output file",
    )
    return parser.parse_args()


def main(args: argparse.Namespace) -> int:
    """Main function."""
    {{_cursor_}}
    return 0


if __name__ == "__main__":
    sys.exit(main(parse_args()))
