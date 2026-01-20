#!/bin/bash

# Oh My Zsh installation script with plugins
# Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, you-should-use, zsh-bat

set -e

echo "=========================================="
echo "  Oh My Zsh Setup"
echo "=========================================="

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "Error: zsh is not installed. Please install zsh first."
    exit 1
fi

# Install Oh My Zsh if not installed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo ""
    echo "[1/5] Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo ""
    echo "[1/5] Oh My Zsh already installed, skipping..."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
echo ""
echo "[2/5] Installing zsh-autosuggestions..."
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed, skipping..."
fi

# Install zsh-syntax-highlighting
echo ""
echo "[3/5] Installing zsh-syntax-highlighting..."
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed, skipping..."
fi

# Install you-should-use
echo ""
echo "[4/5] Installing you-should-use..."
if [[ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ]]; then
    git clone https://github.com/MichaelAqworworq/zsh-you-should-use "$ZSH_CUSTOM/plugins/you-should-use"
else
    echo "you-should-use already installed, skipping..."
fi

# Install zsh-bat
echo ""
echo "[5/5] Installing zsh-bat..."
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-bat" ]]; then
    git clone https://github.com/fdellwing/zsh-bat "$ZSH_CUSTOM/plugins/zsh-bat"
else
    echo "zsh-bat already installed, skipping..."
fi

# Check if bat is installed (required for zsh-bat)
if ! command -v bat &> /dev/null; then
    echo ""
    echo "Note: 'bat' is not installed. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install bat
    else
        echo "Warning: Homebrew not found. Please install 'bat' manually for zsh-bat to work."
    fi
fi

echo ""
echo "=========================================="
echo "  Oh My Zsh Setup Complete!"
echo "=========================================="
echo ""
echo "Add the following plugins to your ~/.zshrc:"
echo ""
echo '  plugins=('
echo '    git'
echo '    zsh-autosuggestions'
echo '    zsh-syntax-highlighting'
echo '    you-should-use'
echo '    zsh-bat'
echo '  )'
echo ""
echo "Then reload your shell:"
echo "  source ~/.zshrc"
echo ""
