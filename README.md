# Polkadot Hardhat Quickstart DevContainer

🚀 Zero-configuration development environment for Polkadot smart contracts using Hardhat.

[![Open in VS Code](https://img.shields.io/static/v1?logo=visualstudiocode&label=&message=Open%20in%20VS%20Code&labelColor=2c2c32&color=007ACC&logoColor=007ACC)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/UtkarshBhardwaj007/Polkadot-Hardhat-Quickstart)
[![Docker Image](https://img.shields.io/badge/Docker%20Image-ghcr.io-blue?logo=docker)](https://github.com/UtkarshBhardwaj007/Polkadot-HardHat-QuickStart/pkgs/container/polkadot-hardhat-quickstart)

## 🚀 Quick Start

### Option 1: Use the Button (Easiest)

WIP

### Option 2: Use Docker Directly

```bash
# Create a new project directory
mkdir my-polkadot-project && cd my-polkadot-project

# Run the DevContainer - it automatically initializes everything!
docker run -it --rm -v $(pwd):/project ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:latest

# Setup your private key
npx hardhat vars set TEST_ACC_PRIVATE_KEY <your_private_key>
```

This will automatically:
- ✅ Create the complete project structure
- ✅ Install all dependencies
- ✅ Download platform-specific binaries
- ✅ Configure Hardhat for Polkadot
- ✅ Provide example contracts and tests

If you exit the terminal and want to re-open it, just run the same docker run command again.

![Docker Build](https://github.com/UtkarshBhardwaj007/Polkadot-Hardhat-Quickstart/actions/workflows/docker-publish.yml/badge.svg)
