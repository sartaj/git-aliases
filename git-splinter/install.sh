#!/bin/bash

##
## Config
##
SCRIPT_URL="https://raw.githubusercontent.com/sartaj/git-aliases/refs/heads/main/git-splinter/git-splinter.sh"
ALIAS="splinter"
DESCRIPTION="Push staged changes to a new branch off of main. Useful for hotfixes and splitting large branches."
INSTALL_DIR="$HOME/.git-aliases"

##
## Run
##

echo ""
echo "📥 Installing $ALIAS..."

# Exit immediately if a command exits with a non-zero status
set -e

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Download the script
SCRIPT="$ALIAS.sh"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT"
echo "🔧 Downloading script to $SCRIPT_PATH"
curl -s "$SCRIPT_URL" > "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

# Set up the Git alias
echo "🔧 Setting up git alias..."
# Remove any existing alias first
git config --global --unset-all "alias.${ALIAS}" || true
git config --global "alias.${ALIAS}" "!${SCRIPT_PATH}"
git config --global "alias.${ALIAS}.description" "${DESCRIPTION}"

echo "✅ Installed git-$ALIAS successfully"
echo ""