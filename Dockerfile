FROM lubien/tired-proxy:2 as proxy
FROM debian:stable-slim

# Install build dependencies
RUN apt-get update -y \
    && apt-get install -y build-essential git unzip curl zsh \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Prepare build dir
WORKDIR /workspace/settings
RUN mkdir -p /workspace/settings

ENV SHELL=/bin/bash

# Install fly cli
RUN curl -L https://fly.io/install.sh | sh \
    && echo 'export FLYCTL_INSTALL="/root/.fly"' >> ~/.bashrc \
    && echo 'export PATH="$FLYCTL_INSTALL/bin:$PATH"' >> ~/.bashrc

# Install rust
ENV CARGO_HOME=/workspace/settings/cargo
ENV RUSTUP_HOME=/workspace/settings/rustup
RUN mkdir -p /workspace/settings/cargo \
    && mkdir -p /workspace/settings/rustup \
    && echo 'export PATH="/workspace/settings/cargo/bin:$PATH"' >> ~/.bashrc
RUN RUSTUP_HOME=/workspace/settings/rustup CARGO_HOME=/workspace/settings/cargo bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'

# Install nvm
ENV NVM_DIR=/workspace/settings/nvm
RUN mkdir -p /workspace/settings/nvm \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Install oh my zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- -y

# Install deno
ENV DENO_INSTALL=/workspace/settings/deno
RUN echo 'export PATH="/workspace/settings/deno/bin:$PATH"' >> ~/.bashrc \
    && curl -fsSL https://deno.land/x/install/install.sh | sh

# Install bun
ENV BUN_INSTALL=/workspace/settings/bun
RUN echo 'export PATH="/workspace/settings/bun/bin:$PATH"' >> ~/.bashrc \
    && curl -fsSL https://bun.sh/install | bash

#===============================
# Move installed programs to /build-out, this will be later used to move them to the mount fly storage
RUN mkdir /build-out \
    && mv /workspace/settings/* /build-out

# Use our custom entrypoint script first
COPY entrypoint.sh /entrypoint.sh

COPY --from=proxy /tired-proxy /tired-proxy

ENTRYPOINT ["/entrypoint.sh"]