# GitHub Actions Docker Publishing

This workflow automatically builds and publishes the Docker image to GitHub Container Registry.

## How it works

### Triggers
- **Push to main**: Builds and publishes with `main` tag
- **Version tags**: Push a tag like `v1.0.0` to publish a versioned release
- **Pull requests**: Builds but doesn't push (for testing)
- **Manual dispatch**: Run manually from Actions tab

### What it does

1. **Multi-platform build**: Builds for both `linux/amd64` and `linux/arm64`
2. **Automatic tagging**:
   - `latest` - Always points to main branch
   - `main` - Latest commit on main branch
   - `v1.0.0` - Specific version (when you push a tag)
   - `v1.0` - Latest patch version of v1.0.x
   - `pr-123` - For pull requests (not pushed)

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
ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:v1.0.0
ghcr.io/utkarshbhardwaj007/polkadot-hardhat-quickstart:main
```

Note: The repository name is automatically converted to lowercase.

### Package Visibility

After the first push, you may want to make your package public:
1. Go to your GitHub profile → Packages
2. Click on `polkadot-hardhat-quickstart`
3. Package settings → Change visibility → Public
