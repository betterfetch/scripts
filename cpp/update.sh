#!/bin/bash

set -e

REPO_URL="https://github.com/betterfetch/betterfetch-cpp.git"
INSTALL_DIR="$HOME/.betterfetch-cpp"
BINARY_NAME="betterfetch"
INSTALL_BIN_PATH="/usr/local/bin/$BINARY_NAME"

echo "Starting betterfetch C++ update..."

# Check for C++ compiler
if command -v g++ >/dev/null 2>&1; then
	COMPILER="g++"
elif command -v clang++ >/dev/null 2>&1; then
	COMPILER="clang++"
else
	echo "No C++ compiler found. Please install g++ or clang++ first."
	exit 1
fi

echo "Using compiler: $COMPILER"

# Clone repo if missing
if [ ! -d "$INSTALL_DIR" ]; then
	echo "betterfetch C++ repo not found, cloning..."
	git clone "$REPO_URL" "$INSTALL_DIR"
else
	echo "Updating betterfetch C++ repository..."
	git -C "$INSTALL_DIR" pull
fi

cd "$INSTALL_DIR"

# Build binary directly without cmake/make
echo "Compiling betterfetch..."
$COMPILER -O2 -std=c++17 -o "$BINARY_NAME" *.cpp

# Install binary
echo "Installing updated binary to $INSTALL_BIN_PATH"
if [ -w /usr/local/bin ]; then
	cp "$BINARY_NAME" "$INSTALL_BIN_PATH"
else
	sudo cp "$BINARY_NAME" "$INSTALL_BIN_PATH"
fi

echo "betterfetch C++ updated successfully!"
