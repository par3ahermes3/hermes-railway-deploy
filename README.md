# Hermes Agent - Railway Deployment

This repository contains the necessary files to deploy [Hermes Agent](https://github.com/NousResearch/hermes-agent) on Railway (or any other Docker-based PaaS).

## Setup Instructions for Railway

1. Click **New Project** in Railway.
2. Select **Deploy from GitHub repo** and choose this repository.
3. Once deployed, go to the **Variables** tab and add the following:

### Required Variables
Choose at least one AI provider:
- `OPENROUTER_API_KEY`: Your OpenRouter API key
- `ANTHROPIC_API_KEY`: Your Anthropic API key
- `GEMINI_API_KEY`: Your Google Gemini API key

### Telegram Bot Variables
To control Hermes via Telegram:
- `TELEGRAM_BOT_TOKEN`: The token from @BotFather
- `TELEGRAM_ALLOWED_USERS`: Your Telegram numeric User ID (comma separated if multiple)

### Optional Variables
- `DEFAULT_MODEL`: e.g., `anthropic/claude-3-7-sonnet-20250219` or `google/gemini-2.5-pro`

## How it works

The Dockerfile installs Python 3.11, the required system dependencies, and then installs Hermes via its official installer script. 
The `entrypoint.sh` script automatically configures the Hermes Gateway based on the environment variables you provide in the Railway dashboard, and then starts the gateway process.
