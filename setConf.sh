#!/usr/bin/env bash
set -e

# === CONFIG ===
DOTFILES_REPO="git@github.com:plsainrat/dotfiles.git"
PKGS="git vim i3 alacritty curl"

# === CHECKS ===
echo "[*] Updating system..."
if command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y $PKGS
elif command -v dnf &>/dev/null; then
    sudo dnf install -y $PKGS
elif command -v pacman &>/dev/null; then
    sudo pacman -Syu --noconfirm $PKGS
else
    echo "Unsupported package manager. Install packages manually: $PKGS"
fi

# === DOTFILES ===
echo "[*] Setting up dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone "$DOTFILES_REPO" "$HOME/.dotfiles"
else
    echo "Dotfiles repo already exists, pulling latest..."
    git -C "$HOME/.dotfiles" pull
fi

# === SYMLINKS ===
ln -sf ~/.dotfiles/alacritty ~/.config/alacritty
ln -sf ~/.dotfiles/i3 ~/.config/i3
ln -sf ~/.dotfiles/vim/.vimrc ~/.vimrc

# === Vim ===
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa


# === OPTIONAL: Additional setup ===
# Example: install fonts or plugins
# mkdir -p ~/.local/share/fonts
# cp ~/.dotfiles/fonts/* ~/.local/share/fonts/
# fc-cache -f -v

echo "[✔] Setup complete! Enjoy your environment."
