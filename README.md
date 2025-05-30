# AutoGen Studio - Visual Agent Workflow Designer

Microsoft's official AutoGen Studio deployed on Fly.io - the complete visual interface for designing and managing multi-agent AI workflows.

## 🎨 **AutoGen Studio**
- **Purpose**: Official Microsoft visual interface for agent workflow design
- **Port**: 8081 (production & local)
- **Features**: Complete drag-and-drop agent orchestration platform

## Features

- 🎨 **Visual Workflow Designer** - Drag-and-drop interface for building agent workflows
- 🔧 **Agent Configuration** - Configure multiple agent types with custom prompts
- 📊 **Conversation Flow Visualization** - See how agents interact in real-time
- 🔄 **Multi-Agent Orchestration** - Complex agent team coordination
- 💾 **Save and Load Workflows** - Persistent workflow management
- 🌐 **Web-Based Interface** - No installation required, browser-based
- ☁️ **Cloud Deployment Ready** - Configured for Fly.io deployment

## 🔐 Authentication Setup (Recommended)

AutoGen Studio includes **GitHub OAuth authentication** to secure your application. This prevents unauthorized access to your agent workflows.

**🔑 Important**: You need **TWO separate GitHub OAuth Apps** - one for local development and one for production, because GitHub OAuth apps only support one callback URL per app.

### 1. Create GitHub OAuth Applications

#### 🏠 **Local Development App**
1. Go to **GitHub** → **Settings** → **Developer settings** → **OAuth Apps**
2. Click **"New OAuth App"**
3. Fill in the details:
   - **Application name**: `AutoGen Studio (Local)`
   - **Homepage URL**: `http://localhost:8081`
   - **Authorization callback URL**: `http://localhost:8081/api/auth/callback`
4. Click **"Register application"**
5. **Copy the Client ID and Client Secret** for your `.env` file

#### 🌐 **Production App**
1. Create another **"New OAuth App"**
2. Fill in the details:
   - **Application name**: `AutoGen Studio`
   - **Homepage URL**: `https://bothire-autogen.fly.dev`
   - **Authorization callback URL**: `https://bothire-autogen.fly.dev/api/auth/callback`
3. Click **"Register application"**
4. **Copy the Client ID and Client Secret** for production deployment

### 2. Configure Environment Variables

The `auth.yaml` file uses environment variables to automatically switch between local and production configurations:

```yaml
type: github
jwt_secret: "${JWT_SECRET}"
token_expiry_minutes: 60
github:
  client_id: "${GITHUB_CLIENT_ID}"
  client_secret: "${GITHUB_CLIENT_SECRET}"
  callback_url: "${CALLBACK_URL}"
  scopes: ["user:email"]
```

#### 🏠 **Local Development** (`.env` file):
```env
OPENAI_API_KEY=your_actual_openai_api_key
JWT_SECRET=7670af6d5b80e22eb7b799afa87494534344724fa6dead3bc84d13d0bdf5d065
GITHUB_CLIENT_ID=your_local_app_client_id
GITHUB_CLIENT_SECRET=your_local_app_client_secret
CALLBACK_URL=http://localhost:8081/api/auth/callback
```

#### 🌐 **Production** (Fly.io secrets):
```bash
# Set production secrets
./scripts/setup-fly-secrets.sh
```

### 3. Quick Setup Helper Scripts

We've created helper scripts to make this easier:

```bash
# Create local OAuth app (guided setup)
./scripts/create-local-oauth.sh

# Set up production secrets
./scripts/setup-fly-secrets.sh

# Complete setup guide
./scripts/oauth-setup-guide.sh
```

### Security Notes

- ✅ **JWT Secret**: Pre-generated secure 32-byte random string
- ✅ **Environment Variables**: Credentials loaded from environment, not hardcoded
- ✅ **Separate Apps**: Local and production use different OAuth apps for security
- ✅ **GitHub OAuth**: Industry-standard authentication
- ⚠️ **Experimental**: Authentication is experimental and may change

## Prerequisites

- Python 3.9 or higher
- Git
- OpenAI API key
- Fly.io account (for deployment)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Bothire-Agent-Marketplace/bothire-autogen.git
cd bothire-autogen
```

### 2. Install uv (Modern Python Package Manager)

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
```

### 3. Set Up Python Environment

```bash
# Create virtual environment
uv venv

# Activate virtual environment
# On macOS/Linux:
source .venv/bin/activate
```

### 4. Install Dependencies

```bash
# Install AutoGen Studio and dependencies
uv pip install -r requirements.txt
```

### 5. Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` and add your OpenAI API key:
```
OPENAI_API_KEY=your_actual_openai_api_key
PORT=8081
```

### 6. Run AutoGen Studio

```bash
./scripts/studio.sh          # Default port 8081
```

Visit: **http://localhost:8081**

**Important**: Always use **Ctrl+C** to stop the application properly.

## Development Scripts

### `./scripts/studio.sh` - AutoGen Studio
```bash
./scripts/studio.sh          # Port 8081
./scripts/studio.sh 3000     # Custom port 3000
```

### `./scripts/cleanup.sh` - Port Cleanup
```bash
./scripts/cleanup.sh 8081   # Clean up port 8081
```

## Project Structure

```
bothire-autogen/
├── scripts/
│   ├── studio.sh       # AutoGen Studio launcher script
│   └── cleanup.sh      # Port cleanup utility
├── Dockerfile          # Docker configuration for AutoGen Studio
├── fly.toml           # Fly.io deployment configuration
├── requirements.txt    # Python dependencies (AutoGen Studio)
├── .env.example       # Environment variables template
├── .gitignore         # Git ignore file
└── README.md          # This file
```

## Deployment to Fly.io

### 1. Install Fly CLI

```bash
# macOS/Linux
curl -L https://fly.io/install.sh | sh

# Add to PATH permanently (bash)
echo 'export FLYCTL_INSTALL="/Users/$USER/.fly"' >> ~/.bash_profile
echo 'export PATH="$FLYCTL_INSTALL/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

### 2. Login to Fly.io

```bash
fly auth login
```

### 3. Deploy AutoGen Studio

```bash
# Create the app (first time only)
fly apps create bothire-autogen

# Set your OpenAI API key as a secret
fly secrets set OPENAI_API_KEY=your_actual_openai_api_key --app bothire-autogen

# Deploy AutoGen Studio
fly deploy --app bothire-autogen
```

Your AutoGen Studio will be available at: **https://bothire-autogen.fly.dev**

## Troubleshooting

### "TypeError: __init__() got an unexpected keyword argument 'proxies'"

This error occurs due to incompatibility between autogen and httpx versions. The `requirements.txt` file includes the correct pinned versions:
- `httpx==0.27.2` (important: not 0.28.0 or higher)
- `openai==1.57.2`
- `pyautogen==0.3.2`

If you still encounter this error, force reinstall:
```bash
uv pip install --force-reinstall httpx==0.27.2
```

### SSL/OpenSSL Warnings

The warning about LibreSSL can be safely ignored. It doesn't affect functionality.

## Development Tips

1. **Virtual Environment**: Always activate your virtual environment before working on the project
2. **Dependencies**: Use `uv pip sync requirements.txt` to ensure exact versions
3. **Environment Variables**: Never commit your `.env` file with real API keys
4. **Local Development**: Use `./scripts/studio.sh` for development with AutoGen Studio
5. **Testing**: Test locally with AutoGen Studio before deploying to Fly.io
6. **Port Management**: Use `./scripts/cleanup.sh` if you encounter port conflicts

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test changes with AutoGen Studio locally (`./scripts/studio.sh`)
4. Make your changes
5. Test deployment configuration if needed
6. Submit a pull request

## License

MIT

## Support

For issues or questions, please open an issue on GitHub.

**Main App**: AutoGen Studio - Microsoft's official visual agent workflow designer
**Deployment**: Fly.io ready
**Purpose**: Professional multi-agent AI workflow development 