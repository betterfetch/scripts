#!/bin/bash
echo "Uninstalling betterfetch(C++)"
echo "input path to the betterfetch(C++) installation directory:"
read INSTALL_DIR
# INSTALL_DIR=$1
CARGO_BIN_PATH=$HOME/.cargo/bin/

rm -rf $INSTALL_DIR

rm $CARGO_BIN_PATH/betterfetch
