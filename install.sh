#!/bin/bash

# Simple installation script for macOS setup
# Installs: Homebrew, yabai, skhd, ghostty
# Clones config repo and sets up .config

set -e

echo "=========================================="
echo "  macOS Development Environment Setup"
echo "=========================================="

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: This script is intended for macOS only."
    exit 1
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo ""
    echo "[1/4] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    fi
else
    echo ""
    echo "[1/4] Homebrew already installed, skipping..."
fi

# Install yabai
echo ""
echo "[2/4] Installing yabai (tiling window manager)..."
if ! brew list yabai &> /dev/null; then
    brew install koekeishiya/formulae/yabai
else
    echo "yabai already installed, skipping..."
fi

# Install skhd
echo ""
echo "[3/4] Installing skhd (hotkey daemon)..."
if ! brew list skhd &> /dev/null; then
    brew install koekeishiya/formulae/skhd
else
    echo "skhd already installed, skipping..."
fi

# Install ghostty
echo ""
echo "[4/4] Installing ghostty (terminal emulator)..."
if ! brew list ghostty &> /dev/null; then
    brew install ghostty
else
    echo "ghostty already installed, skipping..."
fi

# Clone config repo and set up .config
echo ""
echo "=========================================="
echo "  Setting up configuration files..."
echo "=========================================="

CONFIG_DIR="$HOME/.config"
REPO_URL="https://github.com/patelchaitany/config.git"
TEMP_DIR=$(mktemp -d)

# Clone the repo to a temp directory
echo "Cloning config repository..."
git clone "$REPO_URL" "$TEMP_DIR"

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Copy configuration files (excluding .git and install.sh)
echo "Copying configuration files to $CONFIG_DIR..."
for item in "$TEMP_DIR"/*; do
    basename=$(basename "$item")
    # Skip install.sh to avoid overwriting itself
    if [[ "$basename" != "install.sh" ]]; then
        if [[ -e "$CONFIG_DIR/$basename" ]]; then
            echo "  Backing up existing $basename to $basename.backup"
            mv "$CONFIG_DIR/$basename" "$CONFIG_DIR/$basename.backup"
        fi
        cp -r "$item" "$CONFIG_DIR/"
        echo "  Copied $basename"
    fi
done

# Copy hidden files (like .git if needed)
for item in "$TEMP_DIR"/.*; do
    basename=$(basename "$item")
    if [[ "$basename" != "." && "$basename" != ".." && "$basename" != ".git" ]]; then
        cp -r "$item" "$CONFIG_DIR/"
        echo "  Copied $basename"
    fi
done

# Clean up temp directory
rm -rf "$TEMP_DIR"

echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Start yabai:  yabai --start-service"
echo "  2. Start skhd:   skhd --start-service"
echo "  3. Open ghostty: open -a Ghostty"
echo ""
echo "Note: yabai may require additional permissions."
echo "Check: https://github.com/koekeishiya/yabai/wiki"
echo ""
