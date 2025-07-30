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

# Check if private key is already set
echo -e "${BLUE}🔑 Checking for deployment private key...${NC}"
if ! npx hardhat vars has TEST_ACC_PRIVATE_KEY 2>/dev/null; then
    echo -e "${YELLOW}⚠️  No private key found for deployment${NC}"
    echo -e "${BLUE}Please enter your private key for deploying to Polkadot Hub Testnet:${NC}"
    echo -e "${YELLOW}(This will be stored securely using Hardhat's configuration variables)${NC}"
    
    # Read private key securely (without echoing to terminal)
    read -s -p "Private key: " PRIVATE_KEY
    echo ""  # New line after hidden input
    
    if [ -n "$PRIVATE_KEY" ]; then
        # Set the private key using hardhat vars
        echo "$PRIVATE_KEY" | npx hardhat vars set TEST_ACC_PRIVATE_KEY > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Private key saved successfully!${NC}"
            echo -e "${BLUE}You can now deploy to Polkadot Hub Testnet using:${NC}"
            echo -e "  ${GREEN}npx hardhat ignition deploy ignition/modules/MyToken.ts --network polkadotHubTestnet${NC}"
        else
            echo -e "${YELLOW}⚠️  Failed to save private key. You can set it manually later using:${NC}"
            echo -e "  ${GREEN}npx hardhat vars set TEST_ACC_PRIVATE_KEY${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  No private key provided. You can set it later using:${NC}"
        echo -e "  ${GREEN}npx hardhat vars set TEST_ACC_PRIVATE_KEY${NC}"
    fi
else
    echo -e "${GREEN}✓ Private key already configured${NC}"
fi

echo ""

# Execute the command passed to docker run, or start bash if none
if [ "$#" -eq 0 ]; then
    echo -e "${BLUE}Starting interactive shell...${NC}"
    exec /bin/bash
else
    exec "$@"
fi
