# DevOps Final Assessment - Dockerfile
# Multi-stage build for optimized image size

# Stage 1: Base image with Python
FROM python:3.9-slim AS base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set working directory
WORKDIR /app

# Stage 2: Production image
FROM base AS production

# Copy requirements file (if exists)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY hello.py .

# Create non-root user for security
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Health check (optional but good practice)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python hello.py || exit 1

# Set the entrypoint
ENTRYPOINT ["python", "hello.py"]

# Metadata labels
LABEL maintainer="DevOps Engineer" \
      version="1.0" \
      description="DevOps Hello World Application" \
      project="devops-intern-final"
