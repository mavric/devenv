#!/usr/bin/env bash
#
# Mavric DevEnv Installer
# Install AI-guided development skills for Claude Code
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
#
# Or with specific destination:
#   curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash -s -- /path/to/project

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/mavric/devenv"
BRANCH="main"
TEMP_DIR=$(mktemp -d)

# Cleanup on exit
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Main installation
main() {
    local target_dir="${1:-.}"

    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Mavric DevEnv Installer${NC}"
    echo -e "${BLUE}  AI-guided development skills for Claude Code${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Check for git
    if ! command -v git &> /dev/null; then
        log_error "git is required but not installed."
        exit 1
    fi

    # Resolve target directory
    target_dir=$(cd "$target_dir" && pwd)
    log_info "Installing to: $target_dir"

    # Clone repo to temp directory
    log_info "Downloading latest version..."
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR/devenv" 2>/dev/null || {
        log_error "Failed to download. Check your internet connection."
        exit 1
    }

    # Install .claude (merge with existing)
    if [ -d "$target_dir/.claude" ]; then
        log_info "Existing .claude directory found - merging..."
        # Merge: copy our files, preserving user's custom files
        # -n = no clobber (don't overwrite), but we WANT to update our files
        # So we use cp without -n, which overwrites matching files but keeps others
        cp -r "$TEMP_DIR/devenv/install/.claude/"* "$target_dir/.claude/"
        log_success ".claude merged (your custom files preserved)"
    else
        cp -r "$TEMP_DIR/devenv/install/.claude" "$target_dir/.claude"
        log_success ".claude installed"
    fi

    # Install .devenv (merge with existing)
    if [ -d "$target_dir/.devenv" ]; then
        log_info "Existing .devenv directory found - merging..."
        cp -r "$TEMP_DIR/devenv/install/.devenv/"* "$target_dir/.devenv/"
        log_success ".devenv merged (your custom files preserved)"
    else
        cp -r "$TEMP_DIR/devenv/install/.devenv" "$target_dir/.devenv"
        log_success ".devenv installed"
    fi

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Installed:"
    echo "  .claude/   - AI skills and commands"
    echo "  .devenv/   - Development standards and references"
    echo ""
    echo "Get started:"
    echo "  1. Open Claude Code in this directory"
    echo "  2. Say: \"I want to build a SaaS for [your idea]\""
    echo ""
    echo "Available commands:"
    echo "  /start-project   - Start a new project with discovery"
    echo "  /discovery-only  - Run discovery interview only"
    echo ""
    echo "Learn more: https://mavric.github.io/devenv"
    echo ""
}

# Run main with all arguments
main "$@"
