# =============================
# Stage 1: Build environment
# =============================
FROM python:3.11-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc && \
    rm -rf /var/lib/apt/lists/*

# Install pip requirements into a temporary location
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt

# Copy application source
COPY . .

# =============================
# Stage 2: Runtime environment
# =============================
FROM python:3.11-slim

# Install runtime dependencies (e.g., curl for healthcheck)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/usr/local/bin:/install/bin:$PATH" \
    PYTHONPATH="/install/lib/python3.11/site-packages"

# Create user
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash appuser

# Working directory
WORKDIR /app

# Copy dependencies and app code
COPY --from=builder /install /install
COPY --from=builder /app /app

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root
USER appuser

# Expose Flask app port
EXPOSE 8000

# Healthcheck endpoint (assumes /health exists)
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Start the app
CMD ["python", "app.py"]