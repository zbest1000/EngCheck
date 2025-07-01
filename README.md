# EngCheck

> **Modern Engineering Compliance Platform** - AI-powered compliance checker based on OSHA, ISO, NFPA standards with integrated open-webui AI interface

## 🏗️ Architecture Overview

EngCheck is a comprehensive engineering compliance platform built with modern technologies:

### **Frontend Stack**
- **SvelteKit 2.x** - Modern reactive framework with server-side rendering
- **TypeScript** - Type-safe development
- **Tailwind CSS 4.x** - Utility-first styling
- **Vite** - Lightning-fast build tool
- **Web Components** - Reusable UI components

### **Backend Stack** 
- **FastAPI** - High-performance Python async framework
- **PostgreSQL 16** - Primary database with advanced features
- **Redis 7.x** - Caching, session store, and real-time features
- **SQLAlchemy 2.x** - Modern ORM with async support
- **Alembic** - Database migrations
- **Celery** - Distributed task queue

### **AI & ML Integration**
- **Open WebUI** - Forked and integrated AI chat interface
- **OpenAI GPT-4** - Advanced language models
- **LangChain** - AI framework for compliance analysis
- **ChromaDB** - Vector database for semantic search
- **Sentence Transformers** - Text embeddings

### **Infrastructure**
- **Docker & Docker Compose** - Containerization
- **Nginx** - Reverse proxy and load balancer
- **Prometheus & Grafana** - Monitoring and metrics
- **ELK Stack** - Logging and analytics
- **GitHub Actions** - CI/CD pipeline

## 🌟 Features

### Core Compliance Features
- ✅ **Multi-Standard Support** - OSHA, ISO 14001, ISO 45001, NFPA codes
- 📋 **Automated Audits** - AI-powered compliance checking
- 📊 **Real-time Dashboards** - Compliance status monitoring
- 📄 **Report Generation** - Automated compliance reports
- 🔔 **Alert System** - Proactive compliance notifications

### AI-Powered Features
- 🤖 **Integrated Chat Interface** - Open WebUI integration
- 🧠 **Intelligent Document Analysis** - AI document review
- 🔍 **Semantic Search** - Natural language compliance queries
- 📈 **Predictive Analytics** - Risk assessment and forecasting
- 💬 **Multi-Language Support** - Global compliance standards

### Advanced Features
- 🏢 **Multi-Tenant Architecture** - Enterprise-ready
- 🔐 **Advanced Security** - OAuth2, RBAC, audit trails
- 📱 **Progressive Web App** - Mobile-first design
- 🌐 **Real-time Collaboration** - WebSocket-based updates
- 📁 **Document Management** - Centralized compliance docs
- 🔄 **Workflow Automation** - Custom compliance workflows

## 🚀 Quick Start

### Prerequisites
- **Docker & Docker Compose** (recommended)
- **Node.js 18+** 
- **Python 3.11+**
- **PostgreSQL 16+**
- **Redis 7+**

### Option 1: Docker Compose (Recommended)
```bash
git clone https://github.com/zbest1000/EngCheck.git
cd EngCheck
cp .env.example .env
# Edit .env with your configuration
docker-compose up -d
```

### Option 2: Manual Setup
```bash
# Clone repository
git clone https://github.com/zbest1000/EngCheck.git
cd EngCheck

# Backend setup
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python -m alembic upgrade head
python main.py

# Frontend setup (new terminal)
cd frontend
npm install
npm run dev

# Open WebUI setup (new terminal)
cd open-webui
npm install
npm run build
npm run start
```

Access the application:
- **Main App**: http://localhost:3000
- **API Docs**: http://localhost:8000/docs
- **AI Chat**: http://localhost:8080
- **Admin Panel**: http://localhost:3000/admin

## 📁 Project Structure

```
EngCheck/
├── frontend/                    # SvelteKit frontend
│   ├── src/
│   │   ├── routes/             # SvelteKit routes
│   │   ├── lib/                # Shared components
│   │   ├── stores/             # Svelte stores
│   │   └── app.html            # App template
│   ├── static/                 # Static assets
│   ├── package.json
│   └── vite.config.js
│
├── backend/                     # FastAPI backend
│   ├── app/
│   │   ├── api/                # API routes
│   │   ├── core/               # Core functionality
│   │   ├── models/             # SQLAlchemy models
│   │   ├── schemas/            # Pydantic schemas
│   │   ├── services/           # Business logic
│   │   └── utils/              # Utilities
│   ├── alembic/                # Database migrations
│   ├── requirements.txt
│   └── main.py
│
├── open-webui/                  # Forked Open WebUI
│   ├── backend/                # Open WebUI backend
│   ├── src/                    # Open WebUI frontend
│   └── package.json
│
├── infrastructure/              # Infrastructure as Code
│   ├── docker/                 # Docker configurations
│   ├── kubernetes/             # K8s manifests
│   ├── terraform/              # Infrastructure
│   └── monitoring/             # Observability
│
├── docs/                       # Documentation
├── tests/                      # Test suites
├── scripts/                    # Utility scripts
├── docker-compose.yml          # Development environment
├── docker-compose.prod.yml     # Production environment
└── README.md
```

## 🛠️ Development

### Backend Development
```bash
cd backend
source venv/bin/activate
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend Development
```bash
cd frontend
npm run dev -- --host 0.0.0.0 --port 3000
```

### Database Migrations
```bash
cd backend
python -m alembic revision --autogenerate -m "description"
python -m alembic upgrade head
```

### Testing
```bash
# Backend tests
cd backend
python -m pytest

# Frontend tests
cd frontend
npm run test

# E2E tests
npm run test:e2e
=======
pip install -r requirements.txt
python -m engcheck.main
```

## 🚢 Deployment

### Production Deployment
```bash
# Build and deploy
docker-compose -f docker-compose.prod.yml up -d

# Scale services
docker-compose -f docker-compose.prod.yml up -d --scale api=3 --scale worker=2
```

### Kubernetes Deployment
```bash
kubectl apply -f infrastructure/kubernetes/
```

### Environment Variables
See `.env.example` for all configuration options including:
- Database connections
- Redis configuration
- OpenAI API keys
- Security settings
- Feature flags

## 📊 Monitoring & Observability

- **Health Checks**: `/health` endpoint
- **Metrics**: Prometheus metrics at `/metrics`
- **Logs**: Structured JSON logging
- **Tracing**: OpenTelemetry integration
- **Dashboards**: Grafana dashboards included

## 🤝 Contributing
=======
## Tech Stack
The service is written in **Python 3.11** using the following libraries:

- **FastAPI** for the web API
- **Uvicorn** as the ASGI server
- **Pydantic** for data validation

This minimal stack provides a clean and scalable architecture that can easily be
expanded with additional compliance rules and integrations.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow TypeScript/Python style guides
- Write tests for new features
- Update documentation
- Use conventional commits

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Open WebUI** - AI interface foundation
- **FastAPI** - Modern Python web framework
- **SvelteKit** - Reactive frontend framework
- **PostgreSQL** - Robust database system

## 📞 Support

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/zbest1000/EngCheck/issues)
- **Discussions**: [GitHub Discussions](https://github.com/zbest1000/EngCheck/discussions)
- **Email**: support@engcheck.com

---

**Built with ❤️ for engineering compliance and safety**
