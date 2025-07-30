#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Polkadot Hardhat DevContainer Initializer${NC}"
echo -e "${BLUE}============================================${NC}"

# Detect if we're in a cloneInVolume scenario or local mount
if [[ "$PWD" == "/workspaces/"* ]]; then
    echo -e "${YELLOW}📦 Detected VS Code cloneInVolume environment${NC}"
    # In cloneInVolume, the repo is cloned to /workspaces/{repo-name}
    # Template files are in /workspace, we need to copy missing files
    
    # Only copy template files if this is a fresh clone (no node_modules)
    if [ ! -d "node_modules" ]; then
        echo -e "${GREEN}✓ Setting up project from template...${NC}"
        
        # Copy binaries and other template files that might not be in git
        cp -r /workspace/binaries . 2>/dev/null || true
        
        # Install dependencies
        echo -e "${GREEN}✓ Installing dependencies...${NC}"
        npm install
        
        echo -e "${GREEN}✨ Project initialized successfully!${NC}"
    else
        echo -e "${GREEN}✓ Project already initialized${NC}"
    fi
else
    # Local mount scenario - run the original entrypoint
    echo -e "${YELLOW}📦 Detected local mount environment${NC}"
    /usr/local/bin/docker-entrypoint.sh
fi

echo -e "${BLUE}You can now:${NC}"
echo -e "  - Create contracts in the ${GREEN}contracts/${NC} folder"
echo -e "  - Write tests in the ${GREEN}test/${NC} folder"
echo -e "  - Configure deployment in ${GREEN}ignition/modules/${NC}"
echo -e "  - Run ${GREEN}npx hardhat compile${NC} to compile contracts"
echo -e "  - Run ${GREEN}npx hardhat test${NC} to run tests"
echo ""
