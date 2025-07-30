# Polkadot Hardhat Quickstart DevContainer

🚀 Zero-configuration development environment for Polkadot smart contracts using Hardhat.

[![Open in VS Code](https://img.shields.io/static/v1?logo=visualstudiocode&label=&message=Open%20in%20VS%20Code&labelColor=2c2c32&color=007ACC&logoColor=007ACC)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/UtkarshBhardwaj007/Polkadot-Hardhat-Quickstart)
[![Docker Image](https://img.shields.io/badge/Docker%20Image-ghcr.io-blue?logo=docker)](https://github.com/UtkarshBhardwaj007/Polkadot-HardHat-QuickStart/pkgs/container/polkadot-hardhat-quickstart)

## 🚀 Quick Start

### Option 1: Use the Button (Easiest)

Just click the button above to automatically:
- Clone this repository into a Docker volume
- Open it in VS Code with the DevContainer
- Install all dependencies

**Note:** Make sure VS Code is already running before clicking the button.

### Option 2: Clone and Open Locally

1. **Install Prerequisites:**
   - [VS Code](https://code.visualstudio.com/)
   - [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. **IMPORTANT: Check Docker Desktop Settings**
   - Open Docker Desktop → Settings → Resources → File Sharing
   - Ensure `/Users` is in the list (should be there by default)
   - If not, add it and click "Apply & Restart"

3. **Clone and open the repository:**
   ```bash
   git clone https://github.com/UtkarshBhardwaj007/Polkadot-Hardhat-Quickstart.git
   cd Polkadot-Hardhat-Quickstart
   code .
   ```

4. **When VS Code opens:**
   - You'll see a notification to "Reopen in Container" - click it
   - Or use Command Palette (Cmd+Shift+P): `Dev Containers: Reopen in Container`

5. **VS Code will automatically:**
   - Pull the Docker image
   - Create a development container
   - Set up your project files
   - Install dependencies
   - Open a terminal ready for development

### Option 2: Use Docker Directly

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

If you exit the terminal and want to re-open it, just run the same docker
command again.

### Option 3: Start with Empty Folder in VS Code

Perfect for creating a new project from scratch:

1. **Create an empty folder and open it in VS Code:**
   ```bash
   mkdir my-new-polkadot-dapp && cd my-new-polkadot-dapp
   code .
   ```

2. **Create `.devcontainer/devcontainer.json`:**
   ```json
   {
     "name": "Polkadot Hardhat Development",
     "image": "ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:latest",
     "workspaceMount": "source=${localWorkspaceFolder},target=/project,type=bind",
     "workspaceFolder": "/project",
     "postCreateCommand": "echo 'Welcome to Polkadot Hardhat Development!'",
     "remoteUser": "root"
   }
   ```

3. **Reopen in Container** (VS Code will prompt you)

The container will detect the empty folder and automatically set up everything for you!

## 🎯 Features

- **Zero Configuration**: Just open in VS Code and start coding
- **Automatic Project Setup**: Empty folders are automatically initialized
- **Pre-installed Tools**: Node.js 22, Hardhat, and all Polkadot plugins
- **Cross-Platform**: Works on Windows, macOS, and Linux
- **VS Code Integration**: Full IntelliSense, debugging, and extensions support
- **Isolated Environment**: No conflicts with other projects

## 📋 Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) (for DevContainer features)
- [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) (auto-installs when needed)

![Docker Build](https://github.com/UtkarshBhardwaj007/Polkadot-Hardhat-Quickstart/actions/workflows/docker-publish.yml/badge.svg)
