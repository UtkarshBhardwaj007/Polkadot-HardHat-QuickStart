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

# Create binaries directory with placeholders
echo -e "${BLUE}🔧 Setting up binaries...${NC}"
mkdir -p $PROJECT_DIR/binaries
cd $PROJECT_DIR/binaries

# Create placeholder binaries
echo '#!/bin/bash
echo "substrate-node placeholder - download real binary from releases.parity.io"' > substrate-node
echo '#!/bin/bash
echo "eth-rpc placeholder - download real binary from releases.parity.io"' > eth-rpc

chmod +x substrate-node eth-rpc

echo -e "${GREEN}✓ Setup complete!${NC}"
cd $PROJECT_DIR
