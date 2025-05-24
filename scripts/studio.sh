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

# Set environment variables
export OPENAI_API_KEY=$(grep OPENAI_API_KEY .env | cut -d '=' -f2)

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
echo "⚠️  Use Ctrl+C to stop properly"
echo ""

# Start AutoGen Studio with authentication
autogenstudio ui --port $PORT --host 0.0.0.0 --auth-config ./auth.yaml 