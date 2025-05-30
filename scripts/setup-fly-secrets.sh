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
echo "⚠️  You will need to provide your OAuth credentials."
echo "   These should come from your GitHub OAuth App settings:"
echo "   https://github.com/settings/developers"
echo ""

# Prompt for secrets (don't echo sensitive values)
read -p "Enter JWT Secret (press Enter for default): " JWT_SECRET
if [ -z "$JWT_SECRET" ]; then
    JWT_SECRET="7670af6d5b80e22eb7b799afa87494534344724fa6dead3bc84d13d0bdf5d065"
fi

read -p "Enter GitHub Client ID: " GITHUB_CLIENT_ID
read -s -p "Enter GitHub Client Secret (hidden): " GITHUB_CLIENT_SECRET
echo ""
read -p "Enter Callback URL (press Enter for default): " CALLBACK_URL
if [ -z "$CALLBACK_URL" ]; then
    CALLBACK_URL="https://bothire-autogen.fly.dev/api/auth/callback"
fi

read -s -p "Enter OpenAI API Key (optional, hidden): " OPENAI_API_KEY
echo ""

echo ""
echo "Setting secrets..."

# Build secrets command
SECRETS_CMD="fly secrets set JWT_SECRET=\"$JWT_SECRET\" GITHUB_CLIENT_ID=\"$GITHUB_CLIENT_ID\" GITHUB_CLIENT_SECRET=\"$GITHUB_CLIENT_SECRET\" CALLBACK_URL=\"$CALLBACK_URL\""

# Add OpenAI API key if provided
if [ ! -z "$OPENAI_API_KEY" ]; then
    SECRETS_CMD="$SECRETS_CMD OPENAI_API_KEY=\"$OPENAI_API_KEY\""
fi

SECRETS_CMD="$SECRETS_CMD --app $APP_NAME"

# Execute the command
eval $SECRETS_CMD

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully set production OAuth secrets!"
    echo ""
    echo "🔧 Next steps:"
    echo "1. Make sure your GitHub OAuth app callback URL is set to:"
    echo "   $CALLBACK_URL"
    echo ""
    echo "2. Deploy your updated application:"
    echo "   fly deploy --app $APP_NAME"
    echo ""
    echo "3. Your production app will now use the correct OAuth configuration!"
else
    echo "❌ Failed to set secrets. Check your Fly.io configuration."
    exit 1
fi 