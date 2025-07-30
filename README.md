# Polkadot Hardhat Quickstart DevContainer

🚀 Zero-configuration development environment for Polkadot smart contracts using Hardhat.

## Quick Start with Docker

```bash
# Create a new project directory
mkdir my-polkadot-project && cd my-polkadot-project

# Run the DevContainer - it automatically initializes everything!
docker run -it --rm -v $(pwd):/project ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:latest
```

This will automatically:
- ✅ Create the complete project structure
- ✅ Install all dependencies
- ✅ Download platform-specific binaries
- ✅ Configure Hardhat for Polkadot
- ✅ Provide example contracts and tests

![Docker Build](https://github.com/UtkarshBhardwaj007/Polkadot-Hardhat-Quickstart/actions/workflows/docker-publish.yml/badge.svg)
