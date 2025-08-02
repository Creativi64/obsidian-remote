# Docker Workflows

This repository contains multiple GitHub Actions workflows for building and publishing Docker images.

## 📋 Workflow Overview

### 1. `docker-build-and-publish.yml` - Main Build Workflow

**Triggers:**
- Push to `main` or `develop` branch
- Tags with pattern `v*.*.*`
- Pull requests to `main`
- Scheduled: Mondays at 00:00 UTC
- Manual via Workflow Dispatch

**Features:**
- Multi-architecture builds (AMD64 + ARM64)
- Publishes to GitHub Container Registry (ghcr.io)
- Intelligent tag generation based on event type
- GitHub Actions cache for better performance
- Security scanning with Trivy
- Comprehensive build summary

### 2. `multi-arch-docker.yml` - Specialized Multi-Architecture Workflow

**Triggers:**
- Tags with pattern `v*.*.*` or `multi-arch-*`
- Scheduled: Monthly on the 1st at 02:00 UTC
- Manual via Workflow Dispatch

**Features:**
- Uses separate Dockerfiles for each architecture
- Creates individual images per architecture
- Combines them into a multi-architecture manifest
- Supports tag suffixes for Beta/RC builds

## ⚙️ Required Secrets

For full functionality, the following secrets must be configured in the repository:

### GitHub Container Registry (automatically available)
- `GITHUB_TOKEN` - Automatically provided by GitHub

## 🏷️ Tagging Strategy

### Automatic tags based on events:

**Branch Pushes:**
- `main` branch → `latest` tag
- `develop` branch → `edge` tag
- Other branches → `branch-name` tag

**Version Tags:**
- `v1.2.3` → `1.2.3`, `1.2`, `1`, `v1.2.3`
- Additionally always the SHA as `branch-sha` tag

**Pull Requests:**
- `pr-123` tag (for testing only, not pushed)

## 🔧 Configuration

The workflows are ready to use out of the box and require no additional configuration. The `GITHUB_TOKEN` is automatically provided by GitHub.

## 🚀 Usage

### Automatic Builds

The workflows are automatically triggered on:
- Code changes to `main` or `develop`
- Creating version tags (e.g., `v1.0.0`)
- Scheduled builds (weekly/monthly)

### Manual Builds

You can start builds manually via the GitHub Actions interface:

1. Go to Actions → "Build and Publish Docker Images"
2. Click "Run workflow"
3. Select the desired platforms

### Multi-Architecture Builds

For specialized multi-architecture builds:

1. Go to Actions → "Multi-Architecture Docker Build"
2. Click "Run workflow"
3. Optional: Add a tag suffix (e.g., "-beta")

## 📦 Available Images

After successful builds, images are available at:

**GitHub Container Registry:**
```bash
docker pull ghcr.io/creativi64/obsidian-remote:latest
docker pull ghcr.io/creativi64/obsidian-remote:v1.0.0
```

## 🛡️ Security

- Automatic vulnerability scans with Trivy
- Results are displayed in the GitHub Security tab
- SARIF format for better GitHub integration

## 🔍 Troubleshooting

### Build fails
1. Check the logs in the Actions tab
2. Ensure GitHub Container Registry permissions are correct
3. Verify that the Dockerfile files are valid

### Multi-architecture builds fail
1. QEMU and Buildx must be properly configured (done automatically)
2. Check that both Dockerfile variants work
3. Ensure base images are available for both architectures
