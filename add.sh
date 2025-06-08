#!/bin/bash

set -e

REPO_BASE="https://raw.githubusercontent.com/liexner/dotfiles/main"
FILES=(aliases.sh exports.sh)  # Add any other file names here
TARGET_DIR="$HOME/.dotfiles"
BASHRC="$HOME/.bashrc"

echo "📁 Creating $TARGET_DIR..."
mkdir -p "$TARGET_DIR"

echo "⬇️ Downloading dotfiles..."
for file in "${FILES[@]}"; do
    curl -fsSL "$REPO_BASE/$file" -o "$TARGET_DIR/$file"
done

# Add to bashrc if not already there
SOURCE_BLOCK="
# >>> dotfiles setup >>>
for file in \$HOME/.dotfiles/*.sh; do
  [ -f \"\$file\" ] && source \"\$file\"
done
# <<< dotfiles setup <<<
"

if ! grep -q 'dotfiles setup' "$BASHRC"; then
    echo "➕ Adding sourcing block to $BASHRC..."
    echo "$SOURCE_BLOCK" >> "$BASHRC"
else
    echo "✅ dotfiles already sourced in $BASHRC"
fi

echo "🔁 Sourcing $BASHRC..."
source "$BASHRC"

echo "✅ Dotfiles downloaded and active!"
