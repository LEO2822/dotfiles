# 🌸 Dotfiles - Beautiful macOS Terminal Setup

Personal dotfile configurations for terminal setup and management using GNU Stow, featuring Catppuccin theming across Ghostty, Starship, and Tmux.

## ⚡ TL;DR

Beautiful terminal setup with:
- **Ghostty** - Fast GPU-accelerated terminal with Catppuccin theme
- **Starship** - Customizable shell prompt with git info and styling  
- **Tmux** - Terminal multiplexer with plugins and Catppuccin theme
- **Zsh** - Enhanced shell with autosuggestions and modern tools

**Quick Install:**
```bash
git clone https://github.com/LEO2822/dotfiles.git ~/.dotfiles
cd ~/.dotfiles  
chmod +x setup.sh
./setup.sh
```

## 🎨 What You Get

### **Visual Features**
- Catppuccin Mocha color scheme across all tools
- Minimal left prompt with directory and git info
- Right-aligned system information
- Beautiful tmux status bar with session/window info
- GPU-accelerated terminal rendering

### **Productivity Tools**
- **eza** - Modern `ls` replacement with icons and git status
- **zoxide** - Smart directory jumping
- **fzf** - Fuzzy finder integration
- **tmux plugins** - Session management, resurrection, and more

## 🛠 Tools Included

| Tool | Purpose | Config Location |
|------|---------|----------------|
| [Ghostty](https://ghostty.org/) | Terminal Emulator | `~/.config/ghostty/` |
| [Starship](https://starship.rs/) | Shell Prompt | `~/.config/starship.toml` |
| [Tmux](https://github.com/tmux/tmux) | Terminal Multiplexer | `~/.tmux.conf` + `~/.config/tmux/` |
| [GNU Stow](https://www.gnu.org/software/stow/) | Dotfile Management | `.stowrc` |

## 📁 Repository Structure

```
dotfiles/
├── ghostty/           # Ghostty terminal config + catppuccin theme
│   └── .config/ghostty/
├── starship/          # Starship prompt config  
│   └── .config/starship.toml
├── tmux/             # Tmux config + plugins + scripts
│   ├── .tmux.conf
│   └── .config/tmux/
├── zshrc/            # Zsh configuration
│   └── .zshrc
├── .stowrc           # Stow configuration  
├── setup.sh          # Automated installation script
└── README.md         # This file
```

## ⌨️ Key Bindings

### **Tmux** (Prefix: `Ctrl+A`)
| Binding | Action |
|---------|--------|
| `Ctrl+A + I` | Install/update tmux plugins |
| `Ctrl+A + o` | SessionX (session manager) |
| `Ctrl+A + p` | Floating terminal window |
| `Ctrl+A + Ctrl+S` | Save tmux session |
| `Ctrl+A + Ctrl+R` | Restore tmux session |

### **Zsh Shortcuts** 
| Binding | Action |
|---------|--------|
| `Ctrl+E` | Accept autosuggestion |
| `Ctrl+U` | Toggle autosuggestion |
| `Ctrl+K` | Previous command |
| `Ctrl+J` | Next command |

### **Aliases**
```bash
l         # eza -l --icons --git -a
lt        # eza --tree --level=2 --long --icons --git
gc        # git commit -m
gp        # git push origin HEAD
gst       # git status
cl        # clear
```

## 🚀 Manual Installation

### **Prerequisites**
- macOS 13+ 
- Zsh as default shell
- Git installed

### **Step-by-step**
```bash
# 1. Clone this repository
git clone https://github.com/LEO2822/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Install required tools
brew install stow starship tmux zsh-autosuggestions eza zoxide
brew install --cask ghostty

# 4. Install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 5. Apply dotfiles with stow
stow ghostty starship tmux zshrc

# 6. Install tmux plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# 7. Reload shell
source ~/.zshrc
```

## 🎯 Features

- **No bloat** - Removed unnecessary tools (aws, kubectl, k8s, nmap, etc.)
- **Clean paths** - Fixed hardcoded user paths, uses `$HOME` variables
- **Modern tools** - eza, zoxide, fzf for enhanced productivity
- **Plugin management** - Tmux plugins for session management
- **Theme consistency** - Catppuccin across all tools

## 🐛 Troubleshooting

### **Tmux "resurrect file not found"**
This is normal on first run. Save a session with `Ctrl+A + Ctrl+S` to eliminate the warning.

### **Starship not showing**
Ensure `STARSHIP_CONFIG` is set before starship init in `.zshrc`.

### **Ghostty theme not applied** 
Restart Ghostty completely (Cmd+Q) after initial setup.

## 🤝 Contributing

Feel free to fork and customize for your own setup! This configuration is based on [omerxx's dotfiles](https://github.com/omerxx/dotfiles) with personal modifications and cleanup.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Inspired by**: [omerxx/dotfiles](https://github.com/omerxx/dotfiles)  
**Theme**: [Catppuccin](https://github.com/catppuccin/catppuccin)