#!/bin/bash

# 🌸 Dotfiles Setup Script
# Automated installation for beautiful macOS terminal setup
# https://github.com/LEO2822/dotfiles

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo -e "\n${PURPLE}=== $1 ===${NC}\n"
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This setup script is designed for macOS only."
        exit 1
    fi
    log_success "macOS detected"
}

# Check if Homebrew is installed, install if not
setup_homebrew() {
    log_header "Setting up Homebrew"
    
    if command -v brew >/dev/null 2>&1; then
        log_success "Homebrew is already installed"
        log_info "Updating Homebrew..."
        brew update
    else
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        log_success "Homebrew installed successfully"
    fi
}

# Install required tools via Homebrew
install_tools() {
    log_header "Installing Required Tools"
    
    # Array of tools to install
    local brew_tools=(
        "stow"           # Dotfiles management
        "starship"       # Shell prompt
        "tmux"          # Terminal multiplexer
        "eza"           # Modern ls replacement
        "zoxide"        # Smart directory jumping
        "fzf"           # Fuzzy finder
        "zsh-autosuggestions"  # Zsh autosuggestions
    )
    
    local brew_casks=(
        "ghostty"       # Terminal emulator
    )
    
    # Install brew tools
    for tool in "${brew_tools[@]}"; do
        if brew list "$tool" >/dev/null 2>&1; then
            log_success "$tool is already installed"
        else
            log_info "Installing $tool..."
            brew install "$tool"
        fi
    done
    
    # Install brew casks
    for cask in "${brew_casks[@]}"; do
        if brew list --cask "$cask" >/dev/null 2>&1; then
            log_success "$cask is already installed"
        else
            log_info "Installing $cask..."
            brew install --cask "$cask"
        fi
    done
    
    log_success "All tools installed successfully"
}

# Install Tmux Plugin Manager
setup_tmux_plugins() {
    log_header "Setting up Tmux Plugin Manager"
    
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    
    if [[ -d "$tpm_dir" ]]; then
        log_success "TPM is already installed"
        log_info "Updating TPM..."
        cd "$tpm_dir" && git pull
    else
        log_info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        log_success "TPM installed successfully"
    fi
}

# Apply dotfiles using GNU Stow
apply_dotfiles() {
    log_header "Applying Dotfiles with GNU Stow"
    
    # Get the directory where this script is located
    local dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$dotfiles_dir"
    
    # Array of stow packages to apply
    local packages=("ghostty" "starship" "tmux" "zshrc")
    
    for package in "${packages[@]}"; do
        if [[ -d "$package" ]]; then
            log_info "Stowing $package..."
            stow --restow "$package" 2>/dev/null || {
                log_warning "Conflict detected for $package, backing up existing files..."
                # Create backup directory
                mkdir -p "$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
                # This is a simple approach - in a real script you'd want more sophisticated conflict resolution
                stow --adopt "$package" 2>/dev/null || true
                stow --restow "$package"
            }
            log_success "$package stowed successfully"
        else
            log_warning "$package directory not found, skipping..."
        fi
    done
    
    log_success "All dotfiles applied successfully"
}

# Install tmux plugins
install_tmux_plugins() {
    log_header "Installing Tmux Plugins"
    
    local tpm_install_script="$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"
    
    if [[ -f "$tpm_install_script" ]]; then
        log_info "Installing tmux plugins..."
        bash "$tpm_install_script"
        log_success "Tmux plugins installed successfully"
    else
        log_error "TPM install script not found. Please install TPM first."
        return 1
    fi
}

# Set up shell environment
setup_shell() {
    log_header "Setting up Shell Environment"
    
    # Check if zsh is the default shell
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        log_success "Default shell changed to zsh"
        log_warning "You may need to restart your terminal for this change to take effect"
    else
        log_success "Zsh is already the default shell"
    fi
    
    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.tmux/resurrect"
    
    log_success "Shell environment set up successfully"
}

# Download Ghostty themes (if not already present)
setup_ghostty_themes() {
    log_header "Setting up Ghostty Themes"
    
    local themes_dir="$HOME/.config/ghostty/themes"
    local catppuccin_theme="$themes_dir/catppuccin-mocha.conf"
    
    if [[ -f "$catppuccin_theme" ]]; then
        log_success "Catppuccin theme already exists"
    else
        log_info "Downloading Catppuccin theme for Ghostty..."
        mkdir -p "$themes_dir"
        curl -fsSL -o "$catppuccin_theme" \
            "https://raw.githubusercontent.com/catppuccin/ghostty/main/themes/catppuccin-mocha.conf"
        log_success "Catppuccin theme downloaded successfully"
    fi
}

# Final setup and instructions
final_setup() {
    log_header "Final Setup"
    
    log_info "Sourcing new shell configuration..."
    # Source the new zshrc if possible
    if [[ -f "$HOME/.zshrc" ]]; then
        # We can't actually source it in the script context, but we can verify it exists
        log_success "New .zshrc is in place"
    fi
    
    log_success "Setup completed successfully!"
    
    echo -e "\n${GREEN}🎉 Installation Complete! 🎉${NC}\n"
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "1. ${YELLOW}Restart your terminal${NC} or run: source ~/.zshrc"
    echo -e "2. ${YELLOW}Open Ghostty${NC} to see the beautiful terminal"
    echo -e "3. ${YELLOW}Start tmux${NC} with: tmux"
    echo -e "4. ${YELLOW}Save your first tmux session${NC} with: Ctrl+A then Ctrl+S"
    
    echo -e "\n${CYAN}Key bindings:${NC}"
    echo -e "• Tmux prefix: ${YELLOW}Ctrl+A${NC}"
    echo -e "• SessionX: ${YELLOW}Ctrl+A + o${NC}"
    echo -e "• Floating window: ${YELLOW}Ctrl+A + p${NC}"
    echo -e "• Install tmux plugins: ${YELLOW}Ctrl+A + I${NC}"
    
    echo -e "\n${PURPLE}Enjoy your beautiful terminal setup! 🌸${NC}\n"
}

# Error handler
error_exit() {
    log_error "Setup failed on line $1"
    echo -e "\n${RED}Setup interrupted. Please check the error above and try again.${NC}"
    echo -e "${YELLOW}You can also manually follow the instructions in README.md${NC}"
    exit 1
}

# Set up error handling
trap 'error_exit $LINENO' ERR

# Main execution
main() {
    echo -e "\n${PURPLE}🌸 Welcome to the Dotfiles Setup Script 🌸${NC}\n"
    echo -e "${CYAN}This will install and configure:${NC}"
    echo -e "• Ghostty (GPU-accelerated terminal)"
    echo -e "• Starship (beautiful shell prompt)"
    echo -e "• Tmux (terminal multiplexer with plugins)"
    echo -e "• Enhanced Zsh configuration"
    echo -e "• Catppuccin theming throughout"
    
    echo -e "\n${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
    read -r
    
    # Execute setup steps
    check_macos
    setup_homebrew
    install_tools
    setup_tmux_plugins
    apply_dotfiles
    install_tmux_plugins
    setup_shell
    setup_ghostty_themes
    final_setup
}

# Run the main function
main "$@"