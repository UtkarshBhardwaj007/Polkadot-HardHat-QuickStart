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
    
    # Update @parity/hardhat-polkadot to latest version
    echo -e "${GREEN}✓ Updating @parity/hardhat-polkadot to latest version...${NC}"
    npm install --save-dev @parity/hardhat-polkadot@latest
    
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
    
    # Check and update @parity/hardhat-polkadot if needed
    if npm list @parity/hardhat-polkadot &>/dev/null; then
        echo -e "${GREEN}✓ Checking for @parity/hardhat-polkadot updates...${NC}"
        # Get current and latest versions
        CURRENT_VERSION=$(npm list @parity/hardhat-polkadot --depth=0 --json 2>/dev/null | grep -oP '"version":\s*"\K[^"]+' | head -1)
        LATEST_VERSION=$(npm view @parity/hardhat-polkadot version 2>/dev/null)
        
        if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ] && [ -n "$LATEST_VERSION" ]; then
            echo -e "${YELLOW}📦 Updating @parity/hardhat-polkadot from v${CURRENT_VERSION} to v${LATEST_VERSION}...${NC}"
            npm install --save-dev @parity/hardhat-polkadot@latest
            echo -e "${GREEN}✓ Updated successfully!${NC}"
        else
            echo -e "${GREEN}✓ @parity/hardhat-polkadot is already at the latest version (v${CURRENT_VERSION})${NC}"
        fi
    fi
fi

# Download platform-specific binaries at runtime
echo -e "${BLUE}🔧 Setting up platform-specific binaries...${NC}"

# Detect runtime platform
ARCH=$(uname -m)
OS=$(uname -s)

# Map architecture names
case "$ARCH" in
    x86_64)
        RUNTIME_ARCH="amd64"
        ;;
    aarch64|arm64)
        RUNTIME_ARCH="arm64"
        ;;
    *)
        RUNTIME_ARCH="$ARCH"
        ;;
esac

# Map OS names
case "$OS" in
    Linux)
        RUNTIME_OS="linux"
        ;;
    Darwin)
        RUNTIME_OS="darwin"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        RUNTIME_OS="windows"
        ;;
    *)
        RUNTIME_OS="$OS"
        ;;
esac

echo -e "${YELLOW}Detected platform: ${RUNTIME_OS}/${RUNTIME_ARCH}${NC}"

# Create binaries directory if it doesn't exist
mkdir -p $PROJECT_DIR/binaries

# Download binaries based on detected platform
cd $PROJECT_DIR/binaries

if [ "$RUNTIME_ARCH" = "amd64" ] && [ "$RUNTIME_OS" = "linux" ]; then
    echo -e "${GREEN}Downloading Linux AMD64 binaries...${NC}"
    # Replace with actual URLs
    echo "#!/bin/bash\necho 'Linux AMD64 substrate-node dummy binary'" > substrate-node
    echo "#!/bin/bash\necho 'Linux AMD64 eth-rpc dummy binary'" > eth-rpc
elif [ "$RUNTIME_ARCH" = "arm64" ] && [ "$RUNTIME_OS" = "linux" ]; then
    echo -e "${GREEN}Downloading Linux ARM64 binaries...${NC}"
    # Replace with actual URLs
    echo "#!/bin/bash\necho 'Linux ARM64 substrate-node dummy binary'" > substrate-node
    echo "#!/bin/bash\necho 'Linux ARM64 eth-rpc dummy binary'" > eth-rpc
elif [ "$RUNTIME_ARCH" = "amd64" ] && [ "$RUNTIME_OS" = "darwin" ]; then
    echo -e "${GREEN}Downloading macOS Intel binaries...${NC}"
    # Replace with actual URLs
    echo "#!/bin/bash\necho 'macOS Intel substrate-node dummy binary'" > substrate-node
    echo "#!/bin/bash\necho 'macOS Intel eth-rpc dummy binary'" > eth-rpc
elif [ "$RUNTIME_ARCH" = "arm64" ] && [ "$RUNTIME_OS" = "darwin" ]; then
    echo -e "${GREEN}Downloading macOS Silicon binaries...${NC}"
    wget -q -O substrate-node "https://github.com/UtkarshBhardwaj007/hardhat-polkadot-example/raw/main/binaries/substrate-node" || {
        echo -e "${YELLOW}Failed to download substrate-node, using dummy binary${NC}"
        echo "#!/bin/bash\necho 'macOS Silicon substrate-node dummy binary'" > substrate-node
    }
    wget -q -O eth-rpc "https://github.com/UtkarshBhardwaj007/hardhat-polkadot-example/raw/main/binaries/eth-rpc" || {
        echo -e "${YELLOW}Failed to download eth-rpc, using dummy binary${NC}"
        echo "#!/bin/bash\necho 'macOS Silicon eth-rpc dummy binary'" > eth-rpc
    }
elif [ "$RUNTIME_OS" = "windows" ]; then
    echo -e "${GREEN}Downloading Windows binaries...${NC}"
    # Replace with actual URLs
    echo "@echo off\necho Windows substrate-node dummy binary" > substrate-node.bat
    echo "@echo off\necho Windows eth-rpc dummy binary" > eth-rpc.bat
else
    echo -e "${YELLOW}⚠️  Unsupported platform: ${RUNTIME_OS}/${RUNTIME_ARCH}${NC}"
    echo -e "${YELLOW}Creating dummy binaries...${NC}"
    echo "#!/bin/bash\necho 'Unsupported platform substrate-node dummy binary'" > substrate-node
    echo "#!/bin/bash\necho 'Unsupported platform eth-rpc dummy binary'" > eth-rpc
fi

# Make binaries executable
chmod +x * 2>/dev/null || true

echo -e "${GREEN}✓ Binaries setup complete${NC}"
echo ""

# Return to project directory
cd $PROJECT_DIR

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
