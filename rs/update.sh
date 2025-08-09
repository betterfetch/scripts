#!/bin/bash

set -e

REPO_URL="https://github.com/betterfetch/betterfetch.git"
INSTALL_DIR="$HOME/.betterfetch"
CARGO_BIN_PATH="$HOME/.cargo/bin"

echo "Starting betterfetch update..."

# Check if rustc is installed
if ! command -v rustc >/dev/null 2>&1; then
	echo "Rust not found. Installing Rust..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	export PATH="$CARGO_BIN_PATH:$PATH"
else
	echo "Rust is already installed."
fi

# Clone repo if missing
if [ ! -d "$INSTALL_DIR" ]; then
	echo "betterfetch repo not found, cloning..."
	git clone "$REPO_URL" "$INSTALL_DIR"
else
	echo "Updating betterfetch repository..."
	git -C "$INSTALL_DIR" pull
fi

# Install / update
cd "$INSTALL_DIR"
echo "Reinstalling betterfetch..."
cargo install --path . --force

echo "betterfetch updated successfully!"
