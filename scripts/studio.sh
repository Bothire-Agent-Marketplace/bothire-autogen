#!/bin/bash

# AutoGen Studio launch script
PORT=${1:-8081}

echo "🎨 Starting AutoGen Studio on port $PORT..."

# Get the directory of this script and go to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Clean up any existing processes on the port
echo "🧹 Cleaning up port $PORT first..."
./scripts/cleanup.sh $PORT

# Make sure we're in the virtual environment
if [[ "$VIRTUAL_ENV" != *".venv"* ]]; then
    echo "📦 Activating virtual environment..."
    source .venv/bin/activate
fi

# Load environment variables from .env file
if [ -f ".env" ]; then
    echo "🔧 Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
else
    echo "⚠️  No .env file found. Copy .env.example to .env and configure your values."
    echo "   cp .env.example .env"
    exit 1
fi

# Suppress Python warnings for cleaner output
export PYTHONWARNINGS="ignore::UserWarning"
export TOKENIZERS_PARALLELISM=false
export TRANSFORMERS_VERBOSITY=error

# Function to handle cleanup on script exit
cleanup() {
    echo ""
    echo "🛑 Shutting down AutoGen Studio..."
    ./scripts/cleanup.sh $PORT
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

echo "✅ Starting AutoGen Studio with authentication..."
echo "🌐 Access at: http://localhost:$PORT"
echo "🔐 GitHub OAuth authentication enabled"
echo "🔑 Using Client ID: ${GITHUB_CLIENT_ID}"
echo "🔗 Callback URL: ${CALLBACK_URL}"
echo "⚠️  Use Ctrl+C to stop properly"
echo ""

# Start AutoGen Studio with authentication
autogenstudio ui --port $PORT --host 0.0.0.0 --auth-config ./auth.yaml 