#!/bin/bash
set -e

WORKSPACE_DIR="/workspace"
PROJECT_DIR="/project"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Initializing Polkadot Hardhat Project${NC}"
echo -e "${BLUE}====================================${NC}"

# Check if the mounted directory is empty or needs initialization
if [ -z "$(ls -A $PROJECT_DIR 2>/dev/null)" ] || [ ! -f "$PROJECT_DIR/package.json" ]; then
    echo -e "${YELLOW}📦 Setting up new project...${NC}"
    
    # Copy only essential files first (not node_modules)
    echo -e "${GREEN}✓ Copying project files...${NC}"
    cd $WORKSPACE_DIR
    for item in *; do
        if [ "$item" != "node_modules" ]; then
            cp -r "$item" "$PROJECT_DIR/" 2>/dev/null || true
        fi
    done
    cp .gitignore "$PROJECT_DIR/" 2>/dev/null || true
    
    # Change to project directory
    cd $PROJECT_DIR
    
    # Install dependencies
    echo -e "${GREEN}✓ Installing dependencies...${NC}"
    npm install
    
    echo -e "${GREEN}✨ Project initialized!${NC}"
else
    echo -e "${GREEN}✓ Existing project detected${NC}"
    cd $PROJECT_DIR
fi

# Download Linux AMD64 binaries
echo -e "${BLUE}🔧 Setting up binaries...${NC}"
mkdir -p $PROJECT_DIR/binaries
cd $PROJECT_DIR/binaries

echo -e "${GREEN}Downloading Linux AMD64 binaries...${NC}"
wget -q -O substrate-node "http://releases.parity.io/substrate-node/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/substrate-node" || {
    echo -e "${YELLOW}Failed to download substrate-node, using dummy binary${NC}"
    echo "#!/bin/bash" > substrate-node
    echo "echo 'substrate-node dummy binary - download failed'" >> substrate-node
}

wget -q -O eth-rpc "http://releases.parity.io/eth-rpc/polkadot-stable2555-rc5/x86_64-unknown-linux-gnu/eth-rpc" || {
    echo -e "${YELLOW}Failed to download eth-rpc, using dummy binary${NC}"
    echo "#!/bin/bash" > eth-rpc
    echo "echo 'eth-rpc dummy binary - download failed'" >> eth-rpc
}

chmod +x substrate-node eth-rpc

echo -e "${GREEN}✓ Setup complete!${NC}"
cd $PROJECT_DIR
