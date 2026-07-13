#!/bin/bash
set -e

# Setup Hermes Gateway via CLI non-interactively if env vars are present
mkdir -p ~/.hermes
touch ~/.hermes/.env

if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    echo "Configuring Telegram Gateway..."
    
    # Token and allowed users go into .env
    echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" >> ~/.hermes/.env
    
    if [ -n "$TELEGRAM_ALLOWED_USERS" ]; then
        echo "TELEGRAM_ALLOWED_USERS=$TELEGRAM_ALLOWED_USERS" >> ~/.hermes/.env
        
        # Extract the first user ID from the comma-separated list
        FIRST_USER=$(echo "$TELEGRAM_ALLOWED_USERS" | cut -d',' -f1)
        echo "TELEGRAM_HOME_CHANNEL=$FIRST_USER" >> ~/.hermes/.env
    fi
    
    # Explicitly enable Telegram platform in config.yaml
    hermes config set telegram.enabled true
fi

# Set default model if provided
if [ -n "$DEFAULT_MODEL" ]; then
    echo "Setting default model to $DEFAULT_MODEL"
    hermes config set model.default "$DEFAULT_MODEL"
fi

# Set providers if keys exist
if [ -n "$OPENROUTER_API_KEY" ]; then
    echo "OPENROUTER_API_KEY=$OPENROUTER_API_KEY" >> ~/.hermes/.env
    hermes config set model.provider openrouter
fi
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY" >> ~/.hermes/.env
    hermes config set model.provider anthropic
fi

echo "Starting Hermes Gateway..."
exec hermes gateway run
