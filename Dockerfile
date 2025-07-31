# Use the same base image as the devcontainer
FROM mcr.microsoft.com/devcontainers/base:bullseye

# Install Node.js 22 and required tools
RUN apt-get update && \
    apt-get install -y curl wget git && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy only necessary files first for better caching
COPY package*.json ./
COPY README.md ./
COPY tsconfig.json ./
COPY hardhat.config.ts ./
COPY .gitignore ./

# Install dependencies
RUN npm ci

# Update @parity/hardhat-polkadot to latest version
# This ensures the image has a recent version, reducing runtime update frequency
RUN npm install --save-dev @parity/hardhat-polkadot@latest

# Copy source directories
COPY contracts/ ./contracts/
COPY test/ ./test/
COPY ignition/ ./ignition/

# Note: Binaries directory and downloads are handled at runtime in docker-entrypoint.sh
# This ensures the correct binaries are downloaded for the actual runtime platform

# Copy and set up entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set working directory to where user's project will be mounted
WORKDIR /project

# Expose default Hardhat port (if running a local node)
EXPOSE 8545

# Use our initialization script as entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
