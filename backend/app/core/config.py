"""
Application Configuration
Using Pydantic Settings for environment variable management
"""

from typing import List, Optional, Any
from pydantic import BaseSettings, validator, PostgresDsn
from functools import lru_cache
import os


class Settings(BaseSettings):
    """Application settings loaded from environment variables"""
    
    # ===== APPLICATION SETTINGS =====
    APP_NAME: str = "EngCheck"
    APP_VERSION: str = "1.0.0"
    APP_DESCRIPTION: str = "Modern Engineering Compliance Platform"
    DEBUG: bool = True
    ENVIRONMENT: str = "development"
    
    # ===== SECURITY =====
    SECRET_KEY: str = "engcheck-super-secret-key-change-in-production"
    JWT_ALGORITHM: str = "HS256"
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    JWT_REFRESH_TOKEN_EXPIRE_MINUTES: int = 10080
    
    # ===== DATABASE =====
    DATABASE_URL: str = "postgresql://engcheck:engcheck_password@localhost:5432/engcheck"
    DB_POOL_SIZE: int = 20
    DB_MAX_OVERFLOW: int = 10
    DB_POOL_TIMEOUT: int = 30
    DB_POOL_RECYCLE: int = 3600
    
    # ===== REDIS =====
    REDIS_URL: str = "redis://localhost:6379/0"
    REDIS_MAX_CONNECTIONS: int = 20
    
    # ===== AI & ML =====
    OPENAI_API_KEY: Optional[str] = None
    OPENAI_MODEL: str = "gpt-4"
    OPENAI_TEMPERATURE: float = 0.7
    OPENAI_MAX_TOKENS: int = 2000
    
    ANTHROPIC_API_KEY: Optional[str] = None
    
    # ===== MONITORING =====
    ENABLE_METRICS: bool = True
    METRICS_PORT: int = 9090
    SENTRY_DSN: Optional[str] = None
    SENTRY_ENVIRONMENT: str = "development"
    
    # ===== API CONFIGURATION =====
    API_V1_PREFIX: str = "/api/v1"
    API_TITLE: str = "EngCheck API"
    API_DESCRIPTION: str = "Engineering Compliance Platform API"
    API_VERSION: str = "1.0.0"
    DOCS_URL: str = "/docs"
    REDOC_URL: str = "/redoc"
    
    # ===== CORS =====
    CORS_ALLOW_ORIGINS: List[str] = ["http://localhost:3000", "http://localhost:8080"]
    CORS_ALLOW_CREDENTIALS: bool = True
    CORS_ALLOW_METHODS: List[str] = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    CORS_ALLOW_HEADERS: List[str] = ["*"]
    
    # ===== CELERY =====
    CELERY_BROKER_URL: str = "redis://localhost:6379/2"
    CELERY_RESULT_BACKEND: str = "redis://localhost:6379/2"
    
    # ===== FILE STORAGE =====
    UPLOAD_DIRECTORY: str = "./uploads"
    MAX_FILE_SIZE: str = "50MB"
    ALLOWED_FILE_TYPES: List[str] = ["pdf", "doc", "docx", "txt", "xlsx", "xls", "csv", "png", "jpg", "jpeg"]
    
    # ===== EMAIL =====
    SMTP_SERVER: str = "smtp.gmail.com"
    SMTP_PORT: int = 587
    SMTP_USERNAME: Optional[str] = None
    SMTP_PASSWORD: Optional[str] = None
    SMTP_USE_TLS: bool = True
    EMAIL_FROM: str = "noreply@engcheck.com"
    
    # ===== LOGGING =====
    LOG_LEVEL: str = "INFO"
    LOG_FORMAT: str = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    LOG_FILE: str = "./logs/engcheck.log"
    
    # ===== FEATURE FLAGS =====
    FEATURE_AI_ASSISTANT: bool = True
    FEATURE_AUTOMATED_AUDITS: bool = True
    FEATURE_REAL_TIME_MONITORING: bool = True
    FEATURE_COMPLIANCE_DASHBOARD: bool = True
    FEATURE_DOCUMENT_ANALYSIS: bool = True
    FEATURE_WORKFLOW_AUTOMATION: bool = True
    FEATURE_MULTI_TENANT: bool = False
    FEATURE_ADVANCED_ANALYTICS: bool = True
    
    @validator("CORS_ALLOW_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Any) -> List[str]:
        """Parse CORS origins from string or list"""
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)
    
    @validator("DATABASE_URL", pre=True)
    def validate_database_url(cls, v: str) -> str:
        """Validate database URL format"""
        if not v.startswith(("postgresql://", "sqlite:///")):
            raise ValueError("DATABASE_URL must be a valid PostgreSQL or SQLite URL")
        return v
    
    class Config:
        env_file = ".env"
        case_sensitive = True


@lru_cache()
def get_settings() -> Settings:
    """Get cached settings instance"""
    return Settings()


# Global settings instance
settings = get_settings()