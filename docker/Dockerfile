# Multi-stage Dockerfile for a Python web application
# Demonstrates: build/runtime separation, non-root user, slim base image, layer caching

# ---------- Stage 1: Build dependencies ----------
FROM python:3.11-slim AS builder

WORKDIR /build

# Install build deps separately so they don't bloat the runtime image
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install Python deps into a virtualenv we'll copy to the runtime stage
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# ---------- Stage 2: Runtime ----------
FROM python:3.11-slim AS runtime

# Create non-root user (recommended for production containers)
RUN groupadd --system app && useradd --system --gid app --no-create-home app

WORKDIR /app

# Copy only the virtualenv from the builder, not build tools
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Copy application code with correct ownership
COPY --chown=app:app . .

USER app

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health').read()" || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
