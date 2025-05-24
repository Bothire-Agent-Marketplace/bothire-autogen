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
COPY auth-production.yaml ./auth.yaml
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

# Run AutoGen Studio with authentication
CMD ["autogenstudio", "ui", "--port", "8081", "--host", "0.0.0.0", "--auth-config", "./auth.yaml"] 