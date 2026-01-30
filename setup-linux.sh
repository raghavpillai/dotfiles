#!/usr/bin/env bash
set -euo pipefail

# Resolve this script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

echo "==> Installing system packages..."
sudo apt update
sudo apt install -y git curl xclip ranger fzf

# eza (modern ls) - needs separate repo on Ubuntu
if ! command -v eza &> /dev/null; then
    echo "==> Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi

# zoxide
if ! command -v zoxide &> /dev/null; then
    echo "==> Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Starship prompt
if ! command -v starship &> /dev/null; then
    echo "==> Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

echo "==> Linking dotfiles..."
ln -sf "$DOTFILES_DIR/.bashrc.linux" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/.aliases.linux" "$HOME/.aliases"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# Link ranger config
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/.config/ranger" "$HOME/.config/ranger"

# NVM
if [ ! -d "$HOME/.nvm" ]; then
    echo "==> Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Bun
if ! command -v bun &> /dev/null; then
    echo "==> Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
fi

# Install global npm tools (after sourcing nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if command -v npm &> /dev/null; then
    echo "==> Installing npm global tools..."
    npm install -g @raghavp/gen-commit branchlet
fi

echo ""
echo "==> Done! Restart your terminal or run: source ~/.bashrc"
