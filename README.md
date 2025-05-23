# Autogen Python - Fly.io Deployment

This project demonstrates how to deploy an Autogen Python application to Fly.io.

## Project Structure

```
bothire-autogen/
├── app.py              # Main Autogen application
├── Dockerfile          # Docker configuration
├── fly.toml           # Fly.io configuration
├── requirements.txt    # Python dependencies
├── .gitignore         # Git ignore file
└── README.md          # This file
```

## Features

- Multi-agent conversation system using Autogen
- Web interface for interacting with agents
- Dockerized for easy deployment
- Configured for Fly.io deployment

## Local Development

1. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the application:
   ```bash
   python app.py
   ```

## Deployment to Fly.io

1. Install the Fly CLI:
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. Login to Fly.io:
   ```bash
   fly auth login
   ```

3. Launch the app (first time):
   ```bash
   fly launch
   ```

4. Deploy updates:
   ```bash
   fly deploy
   ```

## Environment Variables

- `OPENAI_API_KEY`: Your OpenAI API key (required for GPT models)
- `PORT`: Port for the web server (default: 8080)

## Usage

Once deployed, you can access the web interface to interact with the Autogen agents. The application demonstrates a simple multi-agent conversation system where agents collaborate to solve tasks.

## License

MIT 