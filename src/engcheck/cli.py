"""Command-line interface for EngCheck."""
from __future__ import annotations

import argparse
from pathlib import Path
from typing import List, Dict

from .checklist import generate_checklist
from .document_checker import check_document


# CLI command implementations -------------------------------------------------

def cmd_generate(args: argparse.Namespace) -> None:
    """Generate and print a checklist for the given project type."""
    checklist = generate_checklist(args.project)
    for item in checklist:
        print(f"[{item['id']}] {item['description']}")


def cmd_check(args: argparse.Namespace) -> None:
    """Check the given document against the project checklist."""
    checklist = generate_checklist(args.project)
    flags = check_document(Path(args.file), checklist)
    if not flags:
        print("Document complies with selected standards.")
    else:
        print("Non-compliance detected:")
        for flag in flags:
            print(f"- {flag['item']}: {flag['message']}")


# Top level parser ------------------------------------------------------------

parser = argparse.ArgumentParser(description="EngCheck compliance tool")
subparsers = parser.add_subparsers(dest="command", required=True)

p_gen = subparsers.add_parser("generate-checklist", help="Generate a checklist")
p_gen.add_argument("--project", required=True, help="Project type e.g. electrical")
p_gen.set_defaults(func=cmd_generate)

p_check = subparsers.add_parser("check-document", help="Check a document")
p_check.add_argument("--project", required=True, help="Project type")
p_check.add_argument("file", help="PDF file to check")
p_check.set_defaults(func=cmd_check)


def main(argv: List[str] | None = None) -> None:
    """Entry point for the command line interface."""
    args = parser.parse_args(argv)
    args.func(args)


if __name__ == "__main__":
    main()
