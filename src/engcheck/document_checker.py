from __future__ import annotations

from pathlib import Path
from typing import List, Dict

from PyPDF2 import PdfReader


def extract_text(file_path: Path) -> str:
    """Extract text from a PDF document."""
    reader = PdfReader(str(file_path))
    text = []
    for page in reader.pages:
        if page.extract_text():
            text.append(page.extract_text())
    return "\n".join(text)


def check_document(file_path: Path, checklist: List[Dict]) -> List[Dict]:
    """Check a document against the checklist and return any missing items."""
    text = extract_text(file_path).lower()
    flags = []
    for item in checklist:
        keywords = [kw.lower() for kw in item.get("keywords", [])]
        if not any(kw in text for kw in keywords):
            flags.append({"item": item["id"], "message": item["description"]})
    return flags
