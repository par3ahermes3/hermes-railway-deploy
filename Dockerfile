FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    curl git tmux build-essential sudo script \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Fix s6 gateway service: wrap in script for pseudo-terminal
RUN if [ -d /etc/s6-overlay/s6-rc.d ]; then \
        find /etc/s6-overlay/s6-rc.d -name 'run' 2>/dev/null | while read f; do \
            if grep -q 'hermes gateway' "$f" 2>/dev/null; then \
                sed -i 's|exec hermes gateway run|exec script -qfc "hermes gateway run --force" /dev/null|' "$f"; \
                sed -i 's|hermes gateway run$|script -qfc "hermes gateway run --force" /dev/null|' "$f"; \
            fi; \
        done; \
    fi

WORKDIR /root
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Install as s6 oneshot init service
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d && \
    mkdir -p /etc/s6-overlay/s6-rc.d/entrypoint && \
    printf '#!/bin/bash\nexec /root/entrypoint.sh\n' > /etc/s6-overlay/s6-rc.d/entrypoint/run && \
    chmod +x /etc/s6-overlay/s6-rc.d/entrypoint/run && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/entrypoint
