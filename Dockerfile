# Use the same base image as the devcontainer
FROM mcr.microsoft.com/devcontainers/base:bullseye

# Define build arguments for platform detection
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

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

# Copy source directories
COPY contracts/ ./contracts/
COPY test/ ./test/
COPY ignition/ ./ignition/

# Create binaries directory
RUN mkdir -p binaries

# Download actual binaries based on platform
# Replace the URLs below with actual binary download URLs
RUN echo "Downloading binaries for platform: ${TARGETPLATFORM}, arch: ${TARGETARCH}, os: ${TARGETOS}" && \
    if [ "${TARGETARCH}" = "amd64" ] && [ "${TARGETOS}" = "linux" ]; then \
        echo "Creating Linux AMD64 binaries..." && \
        echo "#!/bin/bash\necho 'Linux AMD64 substrate-node dummy binary'" > binaries/substrate-node && \
        echo "#!/bin/bash\necho 'Linux AMD64 eth-rpc dummy binary'" > binaries/eth-rpc; \
    elif [ "${TARGETARCH}" = "arm64" ] && [ "${TARGETOS}" = "linux" ]; then \
        echo "Creating Linux ARM64 binaries..." && \
        echo "#!/bin/bash\necho 'Linux ARM64 substrate-node dummy binary'" > binaries/substrate-node && \
        echo "#!/bin/bash\necho 'Linux ARM64 eth-rpc dummy binary'" > binaries/eth-rpc; \
    elif [ "${TARGETARCH}" = "amd64" ] && [ "${TARGETOS}" = "darwin" ]; then \
        echo "Creating macOS Intel binaries..." && \
        echo "#!/bin/bash\necho 'macOS Intel substrate-node dummy binary'" > binaries/substrate-node && \
        echo "#!/bin/bash\necho 'macOS Intel eth-rpc dummy binary'" > binaries/eth-rpc; \
    elif [ "${TARGETARCH}" = "arm64" ] && [ "${TARGETOS}" = "darwin" ]; then \
        echo "Downloading macOS Silicon binaries..." && \
        wget -O binaries/substrate-node "https://github.com/UtkarshBhardwaj007/hardhat-polkadot-example/blob/main/binaries/substrate-node" && \
        wget -O binaries/eth-rpc "https://github.com/UtkarshBhardwaj007/hardhat-polkadot-example/blob/main/binaries/eth-rpc"; \
    elif [ "${TARGETOS}" = "windows" ]; then \
        echo "Creating Windows binaries..." && \
        echo "@echo off\necho Windows substrate-node dummy binary" > binaries/substrate-node.bat && \
        echo "@echo off\necho Windows eth-rpc dummy binary" > binaries/eth-rpc.bat; \
    else \
        echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1; \
    fi

# Make binaries executable
RUN chmod +x binaries/* || true

# Copy and set up entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set working directory to where user's project will be mounted
WORKDIR /project

# Expose default Hardhat port (if running a local node)
EXPOSE 8545

# Use our initialization script as entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
