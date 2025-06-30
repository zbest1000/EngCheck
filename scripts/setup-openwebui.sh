#!/bin/bash

# EngCheck - Open WebUI Integration Setup Script
# This script sets up the Open WebUI fork with EngCheck-specific customizations

set -e

echo "🚀 Setting up Open WebUI integration for EngCheck..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    print_error "Please run this script from the EngCheck project root directory"
    exit 1
fi

# Create open-webui directory if it doesn't exist
if [ ! -d "open-webui" ]; then
    print_status "Creating open-webui directory..."
    mkdir -p open-webui
fi

cd open-webui

# Clone Open WebUI if not already present
if [ ! -d ".git" ]; then
    print_status "Cloning Open WebUI repository..."
    git clone https://github.com/open-webui/open-webui.git .
    print_success "Open WebUI repository cloned successfully"
else
    print_status "Open WebUI repository already exists, pulling latest changes..."
    git pull origin main
    print_success "Repository updated"
fi

# Create EngCheck-specific customizations
print_status "Applying EngCheck customizations..."

# Create custom CSS for EngCheck branding
mkdir -p src/lib/assets/css
cat > src/lib/assets/css/engcheck-theme.css << 'EOF'
/* EngCheck Custom Theme for Open WebUI */

:root {
  --primary-color: #0ea5e9;
  --primary-hover: #0284c7;
  --secondary-color: #64748b;
  --success-color: #22c55e;
  --warning-color: #f59e0b;
  --error-color: #ef4444;
  --background-light: #f8fafc;
  --background-dark: #0f172a;
}

/* Custom header styling */
.engcheck-header {
  background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
  border-bottom: 2px solid var(--primary-hover);
}

/* Compliance status indicators */
.compliance-status {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.875rem;
  font-weight: 500;
}

.compliance-status.compliant {
  background-color: #dcfce7;
  color: #166534;
}

.compliance-status.warning {
  background-color: #fef3c7;
  color: #92400e;
}

.compliance-status.critical {
  background-color: #fee2e2;
  color: #991b1b;
}

/* EngCheck branding */
.engcheck-logo {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  color: var(--primary-color);
}
EOF

# Create EngCheck-specific components directory
mkdir -p src/lib/components/engcheck

# Create a custom EngCheck integration component
cat > src/lib/components/engcheck/ComplianceWidget.svelte << 'EOF'
<script lang="ts">
  import { onMount } from 'svelte';
  
  export let complianceData: any = null;
  
  let loading = true;
  let error = null;
  
  onMount(async () => {
    try {
      // Fetch compliance data from EngCheck API
      const response = await fetch(`${import.meta.env.VITE_ENGCHECK_API_URL}/api/v1/compliance/summary`, {
        credentials: 'include'
      });
      
      if (response.ok) {
        complianceData = await response.json();
      } else {
        throw new Error('Failed to fetch compliance data');
      }
    } catch (err) {
      error = err.message;
      console.error('Error fetching compliance data:', err);
    } finally {
      loading = false;
    }
  });
</script>

<div class="compliance-widget bg-white dark:bg-gray-800 rounded-lg p-4 shadow-sm border">
  <h3 class="text-lg font-semibold mb-3 text-gray-900 dark:text-white">
    Compliance Overview
  </h3>
  
  {#if loading}
    <div class="animate-pulse">
      <div class="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
      <div class="h-4 bg-gray-200 rounded w-1/2"></div>
    </div>
  {:else if error}
    <div class="text-red-500 text-sm">
      Error loading compliance data: {error}
    </div>
  {:else if complianceData}
    <div class="space-y-3">
      <div class="flex justify-between items-center">
        <span class="text-sm text-gray-600 dark:text-gray-400">Overall Status</span>
        <span class="compliance-status {complianceData.overall_status}">
          {complianceData.overall_status.toUpperCase()}
        </span>
      </div>
      
      <div class="grid grid-cols-3 gap-4 text-center">
        <div class="bg-green-50 dark:bg-green-900/20 p-2 rounded">
          <div class="text-lg font-semibold text-green-600">{complianceData.compliant_count || 0}</div>
          <div class="text-xs text-green-600">Compliant</div>
        </div>
        <div class="bg-yellow-50 dark:bg-yellow-900/20 p-2 rounded">
          <div class="text-lg font-semibold text-yellow-600">{complianceData.warning_count || 0}</div>
          <div class="text-xs text-yellow-600">Warnings</div>
        </div>
        <div class="bg-red-50 dark:bg-red-900/20 p-2 rounded">
          <div class="text-lg font-semibold text-red-600">{complianceData.critical_count || 0}</div>
          <div class="text-xs text-red-600">Critical</div>
        </div>
      </div>
      
      <div class="pt-2 border-t">
        <a 
          href="{import.meta.env.VITE_ENGCHECK_URL}/dashboard" 
          target="_blank"
          class="text-sm text-blue-600 hover:text-blue-800 underline"
        >
          View Full Dashboard →
        </a>
      </div>
    </div>
  {/if}
</div>

<style>
  .compliance-widget {
    min-height: 200px;
  }
</style>
EOF

# Create environment configuration for Open WebUI with EngCheck integration
cat > .env.example << 'EOF'
# EngCheck Open WebUI Integration Environment Variables

# Database
DATABASE_URL=postgresql://engcheck:engcheck_password@postgres:5432/openwebui

# Redis
REDIS_URL=redis://redis:6379/1
WEBSOCKET_REDIS_URL=redis://redis:6379/1

# WebSocket Support
ENABLE_WEBSOCKET_SUPPORT=true
WEBSOCKET_MANAGER=redis

# Security
WEBUI_SECRET_KEY=openwebui-secret-key-change-in-production

# AI Configuration
OPENAI_API_KEY=your-openai-api-key-here

# EngCheck Integration
ENGCHECK_API_URL=http://backend:8000
ENGCHECK_FRONTEND_URL=http://frontend:3000
VITE_ENGCHECK_API_URL=http://localhost:8000
VITE_ENGCHECK_URL=http://localhost:3000

# Features
ENABLE_RAG=true
ENABLE_WEB_SEARCH=true
ENABLE_IMAGE_GENERATION=false
ENABLE_CODE_EXECUTION=false

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:8080

# Logging
LOG_LEVEL=INFO
EOF

# Create custom Dockerfile for EngCheck integration
cat > Dockerfile.engcheck << 'EOF'
# EngCheck Custom Open WebUI Dockerfile
FROM node:18-alpine as frontend-builder

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build frontend with EngCheck customizations
ENV VITE_ENGCHECK_API_URL=http://localhost:8000
ENV VITE_ENGCHECK_URL=http://localhost:3000
RUN npm run build

# Backend stage
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy backend requirements and install
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ ./backend/

# Copy built frontend
COPY --from=frontend-builder /app/build ./frontend/

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start command
CMD ["python", "-m", "uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8080"]
EOF

# Update package.json to include EngCheck environment variables
if [ -f "package.json" ]; then
    print_status "Updating package.json with EngCheck configurations..."
    
    # Create a backup
    cp package.json package.json.backup
    
    # Add EngCheck-specific scripts (this is a simplified approach)
    # In a real scenario, you'd use jq or a more sophisticated JSON editor
    sed -i 's/"dev": "vite dev"/"dev": "vite dev --host 0.0.0.0 --port 8080"/' package.json
fi

cd ..

# Create initialization script for database setup
cat > scripts/init-multiple-postgres-dbs.sh << 'EOF'
#!/bin/bash

set -e
set -u

function create_user_and_database() {
    local database=$1
    echo "Creating user and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER $database;
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
    echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
    for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
        create_user_and_database $db
    done
    echo "Multiple databases created"
fi
EOF

chmod +x scripts/init-multiple-postgres-dbs.sh

# Create nginx configuration
mkdir -p infrastructure/nginx/conf.d

cat > infrastructure/nginx/conf.d/engcheck.conf << 'EOF'
# EngCheck Nginx Configuration

upstream frontend {
    server frontend:3000;
}

upstream backend {
    server backend:8000;
}

upstream openwebui {
    server openwebui:8080;
}

# Main EngCheck application
server {
    listen 80;
    server_name localhost engcheck.local;
    
    client_max_body_size 50M;
    
    # Frontend routes
    location / {
        proxy_pass http://frontend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
    
    # API routes
    location /api/ {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # Open WebUI routes
    location /chat/ {
        proxy_pass http://openwebui/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support for Open WebUI
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }
    
    # Static files
    location /static/ {
        alias /var/www/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# Direct Open WebUI access (for development)
server {
    listen 8080;
    server_name localhost;
    
    location / {
        proxy_pass http://openwebui;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }
}
EOF

print_success "✅ Open WebUI integration setup completed!"
print_status "Next steps:"
echo "1. Copy .env.example to .env and configure your environment variables"
echo "2. Run 'docker-compose up -d' to start all services"
echo "3. Access the applications:"
echo "   - EngCheck Frontend: http://localhost:3000"
echo "   - EngCheck API: http://localhost:8000/docs"
echo "   - Open WebUI Chat: http://localhost:8080"
echo "   - Integrated via Nginx: http://localhost"

print_warning "⚠️  Remember to:"
echo "1. Set your OpenAI API key in the .env file"
echo "2. Configure compliance standards API keys"
echo "3. Review and customize the Open WebUI integration components"

print_success "🎉 Setup complete! Happy coding!"