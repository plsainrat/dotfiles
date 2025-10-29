#!/usr/bin/env bash
set -e

# === CONFIG ===
DOTFILES_REPO="git@github.com:plsainrat/dotfiles.git"
PKGS=("git" "vim" "i3" "alacritty" "curl")

# === DETECTION PACKAGE MNG ===
if command -v apt &>/dev/null; then
	PKG_MNGR="apt" 
elif command -v dnf &>/dev/null; then
	PKG_MNGR="dnf" 
elif command -v pacman &>/dev/null; then
	PKG_MNGR="pacman" 
else 
	echo " Pas de package manager " 
	exit 1
fi


# === Updates ===
echo "[*] Updating system... using : $PKG_MNGR"
case "$PKG_MNGR" in 
	apt)
		sudo apt update -y
		;;
	dnf)
		sudo dnf check-update || true
		;;
	pacman)
		sudo pacman -Sy --noconfirm
		;;
esac

# === Install Packages ===
echo "Installing packages" 
for pkg in "${PKGS[@]}"; do
	echo "Installing $pkg ..."
	case "$PKG_MNGR" in
	apt)
		if sudo apt install -y "$pkg"; then
			echo "$pkg installed."
		else
			echo "failed to install $pkg, skipping"
		fi
		;;
	dnf)
		if sudo dnf install -y "$pkg"; then
			echo "$pkg installed."
		else
			echo "failed to install $pkg, skipping"
		fi
		;;
	pacman)
		if pacman -S --needed --noconfirm "$pkg"; then
			echo "$pkg installed."
		else
			echo "failed to install $pkg, skipping"
		fi
		;;
	esac
done

# === DOTFILES ===
echo "[*] Setting up dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone "$DOTFILES_REPO" "$HOME/.dotfiles"
    git -C "$HOME/.dotfiles" checkout master
else
    echo "Dotfiles repo already exists, pulling latest..."
    git -C "$HOME/.dotfiles" checkout master
    git -C "$HOME/.dotfiles" pull
fi

# === SYMLINKS ===
ln -sf ~/.dotfiles/alacritty ~/.config/alacritty
ln -sf ~/.dotfiles/i3 ~/.config/i3
ln -sf ~/.dotfiles/vim/.vimrc ~/.vimrc

# === Vim ===
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa


# === OPTIONAL: Additional setup ===
# Example: install fonts or plugins
# mkdir -p ~/.local/share/fonts
# cp ~/.dotfiles/fonts/* ~/.local/share/fonts/
# fc-cache -f -v

echo "[✔] Setup complete! Enjoy your environment."
