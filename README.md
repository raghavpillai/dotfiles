# Raghav's Dotfiles

My macOS dotfiles: zsh + Oh My Zsh (vendored) + Powerlevel10k, aliases, Brewfile, and some global CLIs.

## Quick Setup

```bash
mkdir -p ~/dev && cd ~/dev
git clone git@github.com:raghavpillai/dotfiles.git
cd dotfiles
chmod +x setup.sh && ./setup.sh
exec zsh
```

That's it. `setup.sh` installs Homebrew (if needed), symlinks all dotfiles, runs `brew bundle`, and installs my devtools (gen-commit, branchlet) + Bun.
