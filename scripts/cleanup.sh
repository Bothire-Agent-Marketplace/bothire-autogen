#!/bin/bash

# Clean up script for stuck ports
PORT=${1:-8080}

echo "🧹 Cleaning up processes on port $PORT..."

# Find and kill processes using the port
PIDS=$(lsof -ti :$PORT)

if [ -z "$PIDS" ]; then
    echo "✅ No processes found using port $PORT"
else
    echo "🔍 Found processes: $PIDS"
    echo "💀 Killing processes..."
    echo $PIDS | xargs kill -9
    echo "✅ Processes killed"
fi

# Wait a moment for cleanup
sleep 1

# Verify port is free
if lsof -i :$PORT > /dev/null 2>&1; then
    echo "⚠️  Port $PORT might still be in use"
else
    echo "✅ Port $PORT is now free"
fi 