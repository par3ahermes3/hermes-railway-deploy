#!/bin/bash
set -e

# Setup Hermes Gateway via CLI non-interactively if env vars are present
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    echo "Configuring Telegram Gateway..."
    hermes config set gateway.platforms.telegram.enabled true
    hermes config set gateway.platforms.telegram.bot_token "$TELEGRAM_BOT_TOKEN"
    
    if [ -n "$TELEGRAM_ALLOWED_USERS" ]; then
        hermes config set gateway.platforms.telegram.allowed_users "$TELEGRAM_ALLOWED_USERS"
    fi
fi

# Set default model if provided
if [ -n "$DEFAULT_MODEL" ]; then
    echo "Setting default model to $DEFAULT_MODEL"
    hermes config set model.default "$DEFAULT_MODEL"
fi

# Set providers if keys exist
if [ -n "$OPENROUTER_API_KEY" ]; then
    hermes config set model.provider openrouter
fi
if [ -n "$ANTHROPIC_API_KEY" ]; then
    hermes config set model.provider anthropic
fi

echo "Starting Hermes Gateway..."
exec hermes gateway run
