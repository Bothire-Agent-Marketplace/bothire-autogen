#!/bin/bash

# Fix SSL certificate issues on macOS
echo "🔧 Fixing SSL certificate issues for AutoGen Studio..."

# Method 1: Install certificates using pip
echo "📦 Installing certificates via pip..."
pip install --upgrade certifi

# Method 2: Update macOS certificates
echo "🍎 Updating macOS certificates..."
/Applications/Python\ 3.*/Install\ Certificates.command 2>/dev/null || true

# Method 3: Set environment variables for certificate location
CERT_PATH=$(python -c "import certifi; print(certifi.where())")
export SSL_CERT_FILE="$CERT_PATH"
export REQUESTS_CA_BUNDLE="$CERT_PATH"

echo "✅ SSL certificate path set to: $CERT_PATH"
echo "🔐 Certificates should now work for OAuth callbacks"
echo ""
echo "If issues persist, run AutoGen Studio without authentication:"
echo "  autogenstudio ui --port 8081 --host 0.0.0.0" 