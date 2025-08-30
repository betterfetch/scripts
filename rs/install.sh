#!/bin/env bash

set -e

REPO_URL="https://github.com/betterfetch/betterfetch.git"
INSTALL_DIR="$HOME/.betterfetch"
CARGO_BIN_PATH="$HOME/.cargo/bin"
EXPORT_LINE="export PATH=\"$CARGO_BIN_PATH:\$PATH\""

echo "Starting betterfetch installation..."

# Check if rustc is installed
if ! command -v rustc >/dev/null 2>&1; then
	echo "Rust not found. Installing Rust..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	export PATH="$CARGO_BIN_PATH:$PATH"
else
	echo "Rust is already installed."
fi

# Clone repo if not present
if [ ! -d "$INSTALL_DIR" ]; then
	echo "Cloning betterfetch repository..."
	git clone "$REPO_URL" "$INSTALL_DIR"
else
	echo "betterfetch repo already exists."
fi

cd "$INSTALL_DIR"

echo "Installing betterfetch using cargo..."
cargo install --path .

# Detect shell and update PATH if needed
SHELL_NAME=$(basename "$SHELL")
echo "Detected shell: $SHELL_NAME"

if [ "$SHELL_NAME" = "zsh" ]; then
	SHELL_RC="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
	SHELL_RC="$HOME/.bashrc"
else
	echo "Unknown shell. Please add $CARGO_BIN_PATH to your PATH manually."
	exit 0
fi

if ! grep -Fxq "$EXPORT_LINE" "$SHELL_RC"; then
	echo "Adding cargo bin path to $SHELL_RC"
	echo "" >>"$SHELL_RC"
	echo "# Added by betterfetch installer" >>"$SHELL_RC"
	echo "$EXPORT_LINE" >>"$SHELL_RC"
	echo "Please restart your terminal or run 'source $SHELL_RC' to update your PATH."
else
	echo "Cargo bin path already exists in $SHELL_RC"
fi

echo "betterfetch installation complete!"
