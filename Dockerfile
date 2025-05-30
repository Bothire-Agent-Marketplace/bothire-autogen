# Use Python 3.13 slim image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY requirements.txt .
COPY auth.yaml .
COPY .env.example .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy remaining files
COPY . .

# Create non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8081

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8081
ENV PYTHONWARNINGS="ignore::UserWarning"
ENV TOKENIZERS_PARALLELISM=false
ENV TRANSFORMERS_VERBOSITY=error

# Production OAuth Configuration (overridden by Fly.io secrets)
ENV JWT_SECRET="7670af6d5b80e22eb7b799afa87494534344724fa6dead3bc84d13d0bdf5d065"
ENV GITHUB_CLIENT_ID="Ov23li6hQFeDxfWd5qcp"
ENV GITHUB_CLIENT_SECRET="2820b8f5a021049b5ec73bd64a00717a55e3bed5"
ENV CALLBACK_URL="https://bothire-autogen.fly.dev/api/auth/callback"

# Run AutoGen Studio with authentication
CMD ["autogenstudio", "ui", "--port", "8081", "--host", "0.0.0.0", "--auth-config", "./auth.yaml"] 