# EngCheck

> Compliance checker based on OSHA, ISO, NFPA standards

## Overview
Prototype compliance checker that generates project specific checklists and scans engineering documents for missing requirements.

## Features
- Professional engineering tool
- Modern tech stack implementation
- Production-ready architecture
- Comprehensive documentation

## Quick Start

### Prerequisites
- Node.js 18+ or Python 3.11+
- Git

### Setup
```bash
git clone https://github.com/zbest1000/EngCheck.git
cd EngCheck
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
# install in editable mode to use the ``engcheck`` command
pip install -e .
```

### Usage
Generate a checklist for an electrical project:
```bash
engcheck generate-checklist --project electrical
```

Validate a PDF document:
```bash
engcheck check-document --project electrical path/to/file.pdf
```

## Development
- [ ] Phase 1: Core functionality
- [ ] Phase 2: Advanced features
- [ ] Phase 3: Integrations

## Tech Stack
Modern frameworks and best practices for engineering applications.

## Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License
MIT License - see LICENSE file for details
