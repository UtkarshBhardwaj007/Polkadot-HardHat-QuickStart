# GitHub Actions Docker Publishing

This workflow automatically builds and publishes the Docker image to GitHub Container Registry.

## How it works

### Triggers
- **Push to main**: Builds and publishes with `latest` tag
- **Pull requests**: Builds but doesn't push (for testing)
- **Manual dispatch**: Run manually from Actions tab

### What it does

1. **Single-platform build**: Builds for `linux/amd64`. Runs natively in linux/amd64 and windows and uses emulation for other platforms
2. **Automatic tagging**:
   - `latest` - Always points to latest build from the main branch
3. **Caching**: Uses GitHub Actions cache for faster builds
4. **Attestations**: Generates provenance attestations for supply chain security

### Permissions

The workflow uses `GITHUB_TOKEN` which automatically has permission to push to GitHub Container Registry. No additional secrets needed!

### Usage

1. **For releases**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **For updates**: Just push to main:
   ```bash
   git push origin main
   ```

### Published Image

Your image will be available at:
```
ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:latest
ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:v1.0.0 (if tagged)
```

Note: The repository name is automatically converted to lowercase.
