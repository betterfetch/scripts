#!/bin/bash

set -e

REPO_URL="https://github.com/betterfetch/betterfetch-cpp.git"
INSTALL_DIR="$HOME/.betterfetch-cpp"
BINARY_NAME="betterfetch"
INSTALL_BIN_PATH="/usr/local/bin/$BINARY_NAME"

echo "Starting betterfetch C++ installation..."

# Check for g++ or clang++
if command -v g++ >/dev/null 2>&1; then
	COMPILER="g++"
elif command -v clang++ >/dev/null 2>&1; then
	COMPILER="clang++"
else
	echo "No C++ compiler found. Attempting to install g++..."

	# Try apt for Debian/Ubuntu
	if command -v apt-get >/dev/null 2>&1; then
		sudo apt-get update
		sudo apt-get install -y build-essential
	# Try brew for macOS
	elif command -v brew >/dev/null 2>&1; then
		brew install gcc
	else
		echo "Cannot automatically install g++. Please install a C++ compiler manually."
		exit 1
	fi

	if command -v g++ >/dev/null 2>&1; then
		COMPILER="g++"
	elif command -v clang++ >/dev/null 2>&1; then
		COMPILER="clang++"
	else
		echo "C++ compiler installation failed. Please install manually."
		exit 1
	fi
fi

echo "Using C++ compiler: $COMPILER"

# Clone repo if not present
if [ ! -d "$INSTALL_DIR" ]; then
	echo "Cloning betterfetch C++ repository..."
	git clone "$REPO_URL" "$INSTALL_DIR"
else
	echo "betterfetch C++ repo already exists."
fi

cd "$INSTALL_DIR"

# Build step (adjust if you use make, cmake, or another build system)
if [ -f Makefile ]; then
	echo "Building with make..."
	make
elif [ -f CMakeLists.txt ]; then
	echo "Building with cmake..."
	mkdir -p build
	cd build
	cmake ..
	make
	cd ..
else
	echo "No recognized build system found. Please build manually."
	exit 1
fi

# Find the built binary (assuming in current or build folder)
if [ -f "build/$BINARY_NAME" ]; then
	BINARY_PATH="build/$BINARY_NAME"
elif [ -f "$BINARY_NAME" ]; then
	BINARY_PATH="$BINARY_NAME"
else
	echo "Could not find built binary '$BINARY_NAME'. Please check build output."
	exit 1
fi

echo "Installing binary to $INSTALL_BIN_PATH"

if [ -w /usr/local/bin ]; then
	cp "$BINARY_PATH" "$INSTALL_BIN_PATH"
else
	echo "No write permission to /usr/local/bin, using sudo..."
	sudo cp "$BINARY_PATH" "$INSTALL_BIN_PATH"
fi

# Check if /usr/local/bin is in PATH, add if missing
SHELL_NAME=$(basename "$SHELL")
echo "Detected shell: $SHELL_NAME"

if [ "$SHELL_NAME" = "zsh" ]; then
	SHELL_RC="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
	SHELL_RC="$HOME/.bashrc"
else
	echo "Unknown shell. Please ensure /usr/local/bin is in your PATH manually."
	exit 0
fi

if ! echo "$PATH" | grep -q "/usr/local/bin"; then
	if ! grep -Fxq 'export PATH="/usr/local/bin:$PATH"' "$SHELL_RC"; then
		echo "Adding /usr/local/bin to PATH in $SHELL_RC"
		echo "" >>"$SHELL_RC"
		echo "# Added by betterfetch C++ installer" >>"$SHELL_RC"
		echo 'export PATH="/usr/local/bin:$PATH"' >>"$SHELL_RC"
		echo "Please restart your terminal or run 'source $SHELL_RC' to update your PATH."
	else
		echo "/usr/local/bin already added in $SHELL_RC"
	fi
else
	echo "/usr/local/bin already in PATH"
fi

rm -rf INSTALL_DIR
echo "betterfetch C++ installation complete!"
