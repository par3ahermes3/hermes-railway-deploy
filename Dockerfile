FROM python:3.11-slim

# Install system dependencies required for Hermes and common tools
RUN apt-get update && apt-get install -y \
    curl git tmux build-essential sudo \
    && rm -rf /var/lib/apt/lists/*

# Install uv (used by Hermes installer)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# Install Hermes Agent using the official installer
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

WORKDIR /root

# Add the entrypoint script
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Run Hermes gateway
CMD ["/root/entrypoint.sh"]
