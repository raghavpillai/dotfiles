#!/usr/bin/env bash
set -euo pipefail

# Resolve this script's directory so DOTFILES_DIR works even if cloned elsewhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Install Homebrew (if not installed)
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Link dotfiles (overwrite existing files/symlinks)
ln -sf "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.zprofile"  "$HOME/.zprofile"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.aliases"   "$HOME/.aliases"
ln -sf "$DOTFILES_DIR/.p10k.zsh"  "$HOME/.p10k.zsh"

mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/.config/"* "$HOME/.config/" 2>/dev/null || true

# Link Claude Code config (directory symlink — remove existing dir/symlink first)
if [ -L "$HOME/.claude" ]; then
  rm "$HOME/.claude"
elif [ -d "$HOME/.claude" ]; then
  rm -rf "$HOME/.claude"
fi
ln -s "$DOTFILES_DIR/.claude" "$HOME/.claude"

# Apply Homebrew bundle for this repo if available
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  brew bundle --file="$DOTFILES_DIR/Brewfile"
fi

# Install gen-commit
npm install -g @raghavp/gen-commit

# Install branchlet
npm install -g branchlet

# Bun
curl -fsSL https://bun.com/install | bash