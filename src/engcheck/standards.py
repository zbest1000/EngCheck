"""Utilities for loading and searching standards."""
from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List

BASE_DIR = Path(__file__).resolve().parents[2]
STANDARDS_PATH = BASE_DIR / "standards" / "standards.json"


@dataclass
class Standard:
    """Representation of a standard entry."""

    id: str
    description: str
    projects: List[str]
    keywords: List[str]


def load_standards(path: Path = STANDARDS_PATH) -> List[Standard]:
    """Load all standards from a JSON file."""
    with open(path, "r", encoding="utf-8") as fh:
        data = json.load(fh)
    return [Standard(**item) for item in data]


def filter_by_project(standards: Iterable[Standard], project: str) -> List[Standard]:
    """Return standards applicable to a given project type."""
    return [s for s in standards if project in s.projects]
