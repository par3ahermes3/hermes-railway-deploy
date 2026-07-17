#!/bin/bash
set -e

mkdir -p ~/.hermes
touch ~/.hermes/.env

if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" >> ~/.hermes/.env
    if [ -n "$TELEGRAM_ALLOWED_USERS" ]; then
        echo "TELEGRAM_ALLOWED_USERS=$TELEGRAM_ALLOWED_USERS" >> ~/.hermes/.env
        FIRST_USER=$(echo "$TELEGRAM_ALLOWED_USERS" | cut -d',' -f1)
        echo "TELEGRAM_HOME_CHANNEL=$FIRST_USER" >> ~/.hermes/.env
    fi
    hermes config set telegram.enabled true
fi

[ -n "$MODEL_PROVIDER" ] && hermes config set model.provider "$MODEL_PROVIDER"
[ -n "$MODEL_BASE_URL" ] && hermes config set model.base_url "$MODEL_BASE_URL"
[ -n "$MODEL_API_KEY" ] && hermes config set model.api_key "$MODEL_API_KEY"
[ -n "$MODEL_DEFAULT" ] && hermes config set model.default "$MODEL_DEFAULT"
[ -n "$DEFAULT_MODEL" ] && hermes config set model.default "$DEFAULT_MODEL"

echo "Starting Hermes Gateway..."
exec hermes gateway run --no-supervise --force 2>&1
