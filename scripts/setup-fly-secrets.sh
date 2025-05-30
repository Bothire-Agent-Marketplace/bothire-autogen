#!/bin/bash

echo "🚀 Setting up Fly.io secrets for production OAuth..."
echo "=================================================="
echo ""

# Check if fly CLI is available
if ! command -v fly &> /dev/null; then
    echo "❌ Fly CLI not found. Please install it first:"
    echo "   curl -L https://fly.io/install.sh | sh"
    exit 1
fi

# Check if user is logged in to Fly.io
if ! fly auth whoami &> /dev/null; then
    echo "❌ Not logged in to Fly.io. Please login first:"
    echo "   fly auth login"
    exit 1
fi

APP_NAME="bothire-autogen"

echo "🔑 Setting production OAuth secrets for app: $APP_NAME"
echo ""

# Production OAuth credentials (using existing values)
JWT_SECRET="7670af6d5b80e22eb7b799afa87494534344724fa6dead3bc84d13d0bdf5d065"
GITHUB_CLIENT_ID="Ov23li6hQFeDxfWd5qcp"  
GITHUB_CLIENT_SECRET="2820b8f5a021049b5ec73bd64a00717a55e3bed5"
CALLBACK_URL="https://bothire-autogen.fly.dev/api/auth/callback"

echo "Setting secrets..."

# Set OAuth secrets
fly secrets set \
  JWT_SECRET="$JWT_SECRET" \
  GITHUB_CLIENT_ID="$GITHUB_CLIENT_ID" \
  GITHUB_CLIENT_SECRET="$GITHUB_CLIENT_SECRET" \
  CALLBACK_URL="$CALLBACK_URL" \
  --app $APP_NAME

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully set production OAuth secrets!"
    echo ""
    echo "🔧 Next steps:"
    echo "1. Make sure your GitHub OAuth app callback URL is set to:"
    echo "   https://bothire-autogen.fly.dev/api/auth/callback"
    echo ""
    echo "2. Deploy your updated application:"
    echo "   fly deploy --app $APP_NAME"
    echo ""
    echo "3. Your production app will now use the correct OAuth configuration!"
else
    echo "❌ Failed to set secrets. Check your Fly.io configuration."
    exit 1
fi 