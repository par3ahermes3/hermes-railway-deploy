FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    curl git tmux build-essential sudo \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Fix s6 service: add --force to gateway run so it works without TTY in Docker
RUN if [ -d /etc/s6-overlay/s6-rc.d ]; then \
        find /etc/s6-overlay/s6-rc.d -name 'run' 2>/dev/null | while read f; do \
            if grep -q 'hermes gateway' "$f" 2>/dev/null; then \
                sed -i 's|hermes gateway run$|hermes gateway run --force|' "$f"; \
            fi; \
        done; \
    fi

WORKDIR /root

# Copy entrypoint for env var configuration  
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Install entrypoint as s6 oneshot service (runs before gateway)
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d && \
    mkdir -p /etc/s6-overlay/s6-rc.d/entrypoint && \
    echo '#!/bin/bash' > /etc/s6-overlay/s6-rc.d/entrypoint/run && \
    echo 'exec /root/entrypoint.sh' >> /etc/s6-overlay/s6-rc.d/entrypoint/run && \
    chmod +x /etc/s6-overlay/s6-rc.d/entrypoint/run && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/entrypoint

# Keep s6-overlay as init (do NOT override image's default CMD)
