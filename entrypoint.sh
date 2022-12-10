#!/bin/bash

TIME_TO_SHUTDOWN=1800

chsh -s $(which zsh)
mkdir -p /workspace/settings/code-server
mkdir -p /workspace/projects
echo "Getting programs during build..."
mv /build-out/* /workspace/settings
echo "(done)"

source ~/.bashrc
nvm install 18

code-server --user-data-dir /workspace/settings/code-server --bind-addr 0.0.0.0:9090 /workspace/projects &
    /tired-proxy --port 8080 --host http://localhost:9090 --time $TIME_TO_SHUTDOWN