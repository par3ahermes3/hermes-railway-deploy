FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    curl git tmux build-essential sudo \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Remove s6-overlay services so they don't interfere
RUN rm -rf /etc/s6-overlay /etc/s6 /etc/services.d /etc/cont-init.d 2>/dev/null; \
    rm -f /etc/s6-overlay/s6-rc.d/* 2>/dev/null; \
    true

WORKDIR /root
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]
