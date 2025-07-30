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



# Create a simple init script for private key setup
cat > /tmp/setup_private_key.sh << 'EOF'
#!/bin/bash
# Check and setup private key if needed
cd /project 2>/dev/null || true

echo -e "\033[0;34m🔑 Checking for deployment private key...\033[0m"

# Check if the private key is already set
if npx hardhat vars has TEST_ACC_PRIVATE_KEY 2>/dev/null; then
    echo -e "\033[0;32m✓ Private key already configured\033[0m"
else
    echo -e "\033[1;33m⚠️  No private key found for deployment\033[0m"
    echo -e "\033[0;34mWould you like to set up a private key for deploying to Polkadot Hub Testnet? (y/N)\033[0m"
    read -p "> " SETUP_KEY
    
    if [[ "$SETUP_KEY" =~ ^[Yy]$ ]]; then
        echo -e "\033[0;34mPlease enter your private key:\033[0m"
        echo -e "\033[1;33m(This will be stored securely using Hardhat's configuration variables)\033[0m"
        
        # Read private key securely (without echoing to terminal)
        read -s -p "Private key: " PRIVATE_KEY
        echo ""  # New line after hidden input
        
        if [ -n "$PRIVATE_KEY" ]; then
            # Set the private key using hardhat vars
            echo -e "\033[0;34mSetting private key...\033[0m"
            echo "$PRIVATE_KEY" | npx hardhat vars set TEST_ACC_PRIVATE_KEY
            
            if [ $? -eq 0 ]; then
                echo -e "\033[0;32m✓ Private key saved successfully!\033[0m"
                echo -e "\033[0;34mYou can now deploy to Polkadot Hub Testnet using:\033[0m"
                echo -e "  \033[0;32mnpx hardhat ignition deploy ignition/modules/MyToken.ts --network polkadotHubTestnet\033[0m"
            else
                echo -e "\033[1;33m⚠️  Failed to save private key. You can set it manually using:\033[0m"
                echo -e "  \033[0;32mnpx hardhat vars set TEST_ACC_PRIVATE_KEY\033[0m"
            fi
        fi
    else
        echo -e "\033[1;33mYou can set up a private key later using:\033[0m"
        echo -e "  \033[0;32mnpx hardhat vars set TEST_ACC_PRIVATE_KEY\033[0m"
    fi
fi

echo ""
EOF

chmod +x /tmp/setup_private_key.sh

# Execute the command passed to docker run, or start bash if none
if [ "$#" -eq 0 ]; then
    echo -e "${BLUE}Starting interactive shell...${NC}"
    echo ""
    
    # Start bash and run the setup script after it's ready
    exec /bin/bash -c "source /tmp/setup_private_key.sh; exec /bin/bash"
else
    exec "$@"
fi
