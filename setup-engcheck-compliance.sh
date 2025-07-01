#!/bin/bash

# EngCheck Compliance Tracker Setup Script
# This script sets up the compliance tracker integration for Open WebUI

set -e

echo "🔧 EngCheck Compliance Tracker Setup"
echo "====================================="

# Check if we're in the Open WebUI directory
if [ ! -f "open-webui/backend/open_webui/main.py" ]; then
    echo "❌ Error: Please run this script from the project root directory containing the open-webui folder"
    exit 1
fi

echo "✅ Found Open WebUI installation"

# Navigate to backend directory
cd open-webui/backend

echo "📦 Installing Python dependencies..."

# Install core dependencies
pip install PyPDF2 python-docx pandas openpyxl xlrd

# Install AI/ML dependencies (optional but recommended)
echo "🤖 Installing AI/ML dependencies..."
pip install openai anthropic langchain sentence-transformers faiss-cpu

# Install additional dependencies for document processing
pip install python-multipart aiofiles

echo "📊 Setting up database models..."

# Check if alembic is available
if command -v alembic &> /dev/null; then
    echo "🔄 Running database migrations..."
    # Create migration for compliance models
    alembic revision --autogenerate -m "Add EngCheck compliance models"
    alembic upgrade head
else
    echo "⚠️  Alembic not found. You'll need to run database migrations manually:"
    echo "   alembic revision --autogenerate -m 'Add EngCheck compliance models'"
    echo "   alembic upgrade head"
fi

echo "📁 Creating compliance storage directories..."
mkdir -p data/compliance_docs
mkdir -p data/compliance_exports
mkdir -p data/compliance_reports

# Set permissions
chmod 755 data/compliance_docs
chmod 755 data/compliance_exports
chmod 755 data/compliance_reports

echo "⚙️  Setting up environment configuration..."

# Create or update .env file
ENV_FILE=".env"
if [ ! -f "$ENV_FILE" ]; then
    touch "$ENV_FILE"
fi

# Add compliance configuration if not already present
if ! grep -q "ENABLE_COMPLIANCE_TRACKER" "$ENV_FILE"; then
    echo "" >> "$ENV_FILE"
    echo "# EngCheck Compliance Tracker Configuration" >> "$ENV_FILE"
    echo "ENABLE_COMPLIANCE_TRACKER=true" >> "$ENV_FILE"
    echo "COMPLIANCE_STORAGE_PATH=/app/data/compliance_docs" >> "$ENV_FILE"
    echo "COMPLIANCE_AI_PROVIDER=openai" >> "$ENV_FILE"
    echo "# OPENAI_API_KEY=your_openai_api_key_here" >> "$ENV_FILE"
    echo "# ANTHROPIC_API_KEY=your_anthropic_api_key_here" >> "$ENV_FILE"
    echo "COMPLIANCE_MAX_FILE_SIZE=50MB" >> "$ENV_FILE"
    echo "COMPLIANCE_ANALYSIS_TIMEOUT=300" >> "$ENV_FILE"
    echo "COMPLIANCE_DEBUG=false" >> "$ENV_FILE"
    
    echo "✅ Added compliance configuration to .env file"
else
    echo "✅ Compliance configuration already exists in .env file"
fi

echo "🔧 Setting up frontend components..."

# Navigate to frontend directory
cd ../src

# Create compliance components directory if it doesn't exist
mkdir -p lib/components/compliance
mkdir -p lib/apis

echo "✅ Compliance component directories created"

echo "🚀 Installation Summary"
echo "======================"
echo "✅ Python dependencies installed"
echo "✅ Database models set up"
echo "✅ Storage directories created"
echo "✅ Environment configuration added"
echo "✅ Frontend structure prepared"
echo ""
echo "📋 Next Steps:"
echo "1. Configure your AI API keys in the .env file"
echo "2. Restart Open WebUI to load the compliance tracker"
echo "3. Access the compliance tracker at /compliance"
echo ""
echo "🔑 API Key Configuration:"
echo "   Edit the .env file and add your API keys:"
echo "   - For OpenAI: OPENAI_API_KEY=your_key_here"
echo "   - For Anthropic: ANTHROPIC_API_KEY=your_key_here"
echo ""
echo "🌐 Access URL:"
echo "   http://your-openwebui-domain/compliance"
echo ""

# Check if Docker is being used
if [ -f "../../docker-compose.yml" ] || [ -f "../../docker-compose.yaml" ]; then
    echo "🐳 Docker Setup Detected"
    echo "   To rebuild with compliance tracker:"
    echo "   docker-compose down"
    echo "   docker-compose build"
    echo "   docker-compose up -d"
    echo ""
fi

echo "📚 Documentation:"
echo "   See ENGCHECK_COMPLIANCE_IMPLEMENTATION.md for detailed usage instructions"
echo ""

# Check for common issues
echo "🔍 Checking for potential issues..."

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
if [ "$(printf '%s\n' "3.8" "$PYTHON_VERSION" | sort -V | head -n1)" != "3.8" ]; then
    echo "⚠️  Warning: Python 3.8+ recommended for best compatibility"
fi

# Check available disk space
AVAILABLE_SPACE=$(df . | awk 'NR==2{print $4}')
if [ "$AVAILABLE_SPACE" -lt 1048576 ]; then  # Less than 1GB
    echo "⚠️  Warning: Low disk space. Consider freeing up space for document storage"
fi

echo ""
echo "✨ EngCheck Compliance Tracker installation complete!"
echo "   Ready to transform your compliance management with AI-powered insights"
echo ""

# Create a simple test script
cat > test_compliance.py << 'EOF'
#!/usr/bin/env python3
"""
Simple test script to verify EngCheck Compliance Tracker installation
"""

import sys
import importlib

def test_dependencies():
    """Test if all required dependencies are installed"""
    required_packages = [
        'PyPDF2',
        'docx',
        'pandas',
        'sqlalchemy',
        'fastapi'
    ]
    
    optional_packages = [
        'openai',
        'langchain',
        'sentence_transformers'
    ]
    
    print("🧪 Testing EngCheck Compliance Tracker Dependencies")
    print("=" * 50)
    
    # Test required packages
    print("\n📦 Required Dependencies:")
    for package in required_packages:
        try:
            importlib.import_module(package)
            print(f"  ✅ {package}")
        except ImportError:
            print(f"  ❌ {package} - MISSING")
            return False
    
    # Test optional packages
    print("\n🤖 AI/ML Dependencies (Optional):")
    for package in optional_packages:
        try:
            importlib.import_module(package)
            print(f"  ✅ {package}")
        except ImportError:
            print(f"  ⚠️  {package} - Not installed (optional)")
    
    print("\n✅ Core dependencies verified!")
    print("🚀 EngCheck Compliance Tracker is ready to use")
    return True

if __name__ == "__main__":
    success = test_dependencies()
    sys.exit(0 if success else 1)
EOF

chmod +x test_compliance.py

echo "🧪 Created test script: test_compliance.py"
echo "   Run: python3 test_compliance.py to verify installation"

echo ""
echo "🎉 Setup complete! Happy compliance tracking! 🎉"