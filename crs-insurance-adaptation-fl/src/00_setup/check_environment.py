"""Basic environment checks.

This script intentionally stays lightweight so `make setup` works early.
"""

import sys

REQUIRED_MAJOR = 3
REQUIRED_MINOR = 10


def main() -> None:
    if sys.version_info < (REQUIRED_MAJOR, REQUIRED_MINOR):
        raise SystemExit(f"Python {REQUIRED_MAJOR}.{REQUIRED_MINOR}+ required, got {sys.version}")
    print("Environment OK.")


if __name__ == "__main__":
    main()
