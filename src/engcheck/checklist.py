"""Checklist generation utilities."""
from __future__ import annotations

from typing import List, Dict

from .standards import Standard, load_standards, filter_by_project


def generate_checklist(project_type: str) -> List[Dict]:
    """Generate a checklist for a given project type."""
    standards = filter_by_project(load_standards(), project_type)
    # Convert Standard objects back to dictionaries for compatibility
    return [s.__dict__ for s in standards]
