#!/bin/bash

# Smart AutoGen Studio launch script that detects environment
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

# Detect if running on Fly.io or locally
if [ "$FLY_APP_NAME" = "bothire-autogen" ] || [ "$FLY_REGION" != "" ]; then
    echo "🚀 Detected Fly.io environment - using production auth config"
    AUTH_CONFIG="./auth-production.yaml"
    BASE_URL="https://bothire-autogen.fly.dev"
else
    echo "💻 Detected local environment - using local auth config"
    AUTH_CONFIG="./auth.yaml"
    BASE_URL="http://localhost:$PORT"
fi

echo "✅ Starting AutoGen Studio with authentication..."
echo "🌐 Access at: $BASE_URL"
echo "🔐 GitHub OAuth authentication enabled"
echo "📄 Using auth config: $AUTH_CONFIG"
echo "⚠️  Use Ctrl+C to stop properly"
echo ""

# Start AutoGen Studio with appropriate auth config
autogenstudio ui --port $PORT --host 0.0.0.0 --auth-config $AUTH_CONFIG 