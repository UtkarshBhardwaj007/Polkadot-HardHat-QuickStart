#!/bin/bash
set -e

WORKSPACE_DIR="/workspace"
PROJECT_DIR="/project"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Polkadot Hardhat DevContainer Initializer${NC}"
echo -e "${BLUE}============================================${NC}"

# Check if the mounted directory is empty or needs initialization
if [ -z "$(ls -A $PROJECT_DIR 2>/dev/null)" ] || [ ! -f "$PROJECT_DIR/package.json" ]; then
    echo -e "${YELLOW}📦 Initializing new Polkadot Hardhat project...${NC}"
    
    # Copy all template files
    echo -e "${GREEN}✓ Copying project template files...${NC}"
    cp -r $WORKSPACE_DIR/* $PROJECT_DIR/ 2>/dev/null || true
    cp $WORKSPACE_DIR/.gitignore $PROJECT_DIR/ 2>/dev/null || true
    
    # Change to project directory
    cd $PROJECT_DIR
    
    # Install dependencies
    echo -e "${GREEN}✓ Installing dependencies (this may take a few minutes)...${NC}"
    npm install
    
    echo -e "${GREEN}✨ Project initialized successfully!${NC}"
    echo -e "${BLUE}You can now:${NC}"
    echo -e "  - Create contracts in the ${GREEN}contracts/${NC} folder"
    echo -e "  - Write tests in the ${GREEN}test/${NC} folder"
    echo -e "  - Configure deployment in ${GREEN}ignition/modules/${NC}"
    echo -e "  - Run ${GREEN}npx hardhat compile${NC} to compile contracts"
    echo -e "  - Run ${GREEN}npx hardhat test${NC} to run tests"
    echo ""
else
    echo -e "${GREEN}✓ Existing project detected${NC}"
    cd $PROJECT_DIR
fi

# Execute the command passed to docker run, or start bash if none
if [ "$#" -eq 0 ]; then
    echo -e "${BLUE}Starting interactive shell...${NC}"
    exec /bin/bash
else
    exec "$@"
fi
