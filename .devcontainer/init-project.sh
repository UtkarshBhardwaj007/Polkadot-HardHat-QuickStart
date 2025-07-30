#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Initializing Polkadot Hardhat Project${NC}"
echo -e "${BLUE}=========================================${NC}"

# Get the current working directory (VS Code sets this correctly)
CURRENT_DIR=$(pwd)
echo -e "${GREEN}Working directory: $CURRENT_DIR${NC}"

# Check if we need to copy template files
if [ ! -f "package.json" ] && [ -d "/workspace" ]; then
    echo -e "${YELLOW}📦 Setting up project from template...${NC}"
    
    # Copy all template files from /workspace
    if [ -d "/workspace" ]; then
        cp -r /workspace/* . 2>/dev/null || true
        cp /workspace/.gitignore . 2>/dev/null || true
        echo -e "${GREEN}✓ Template files copied${NC}"
    fi
fi

# Install dependencies if package.json exists
if [ -f "package.json" ]; then
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    npm install
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${YELLOW}⚠️  No package.json found in $CURRENT_DIR${NC}"
fi

echo -e "${GREEN}✨ Initialization complete!${NC}"
echo -e "${BLUE}You can now:${NC}"
echo -e "  - Create contracts in the ${GREEN}contracts/${NC} folder"
echo -e "  - Write tests in the ${GREEN}test/${NC} folder"
echo -e "  - Run ${GREEN}npx hardhat compile${NC} to compile contracts"
echo -e "  - Run ${GREEN}npx hardhat test${NC} to run tests"
