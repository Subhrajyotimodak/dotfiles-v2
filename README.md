# 🌈 My Dotfiles

![GitHub last commit](https://img.shields.io/github/last-commit/Subhrajyotimodak/dotfiles-v2?style=flat-square)
![GitHub repo size](https://img.shields.io/github/repo-size/Subhrajyotimodak/dotfiles-v2?style=flat-square)
![Maintained](https://img.shields.io/maintenance/yes/2025?style=flat-square)

## 🚀 Quick Overview

Welcome to my personal dotfiles repository! This collection represents my carefully curated development environment configuration, designed to boost productivity and maintain consistency across different machines.

## 🛠 Configuration Highlights

### 📦 Included Configurations

- **Shell**: Zsh with Oh My Zsh
- **Editor**: Neovim/Vim
- **Terminal**: Wezterm
- **Version Control**: Git

### 🎨 Color Schemes

- Unified color palette across tools
- Dark mode optimized
- Easy-to-read syntax highlighting

## 🔧 Installation

### Automatic Install

```bash
brew install stow
git clone https://github.com/Subhrajyotimodak/dotfiles-v2.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

## 💡 Key Features

- 🔒 Secure and minimal configuration
- 🔄 Cross-platform compatibility
- 🚀 Performance-optimized settings
- 🤖 Automated setup scripts
- 🔀 GitHub account switcher for managing multiple git identities

## 🛡️ Requirements

- Git
- Zsh
- Neovim (required)
- Stow

## 🔀 GitHub Account Switcher

The `github-switch` CLI tool allows you to view and switch between multiple GitHub accounts per repository.

### Setup

1. Copy the example accounts file:

   ```bash
   mkdir -p ~/.config/github-switch
   cp ~/.dotfiles/.config/github-switch/accounts.conf.example ~/.config/github-switch/accounts.conf
   ```

2. Edit `~/.config/github-switch/accounts.conf` with your account details (tab-separated: `<profile>\t<name>\t<email>`)

3. Add to your `.zshrc`:
   ```bash
   alias github-switch="$HOME/.config/github-switch.sh"
   alias ghs='github-switch'  # optional short alias
   ```

### Usage

- `github-switch current` - Show current git identity (username and email)
- `github-switch list` - List available account profiles
- `github-switch use <profile>` - Switch current repo to use a specific profile
- `github-switch help` - Show usage information

**Note:** The `use` command only works inside a git repository and sets per-repo configuration (does not affect global git config).

## 🤝 Contributing

Feel free to fork it, customise it, and submit pull requests. Good ideas are always welcome!
And even if I don't accept the PR, I'll definitely add them below as a list:

---

**Made with ❤️ and ☕ by [Subhrajyoti Modak](https://github.com/subhrajyotimodak)**
