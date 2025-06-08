#!/bin/bash

set -e

REPO_URL="https://raw.githubusercontent.com/liexner/dotfiles/main/files"
FILES=(
  aliases.sh
)

TARGET_DIR="$HOME/.dotfiles"
BASHRC="$HOME/.bashrc"

echo "📁 Creating $TARGET_DIR..."
mkdir -p "$TARGET_DIR"

echo "⬇️ Downloading files into $TARGET_DIR..."
for file in "${FILES[@]}"; do
    echo "  - $file"
    curl -fsSL "$REPO_URL/$file" -o "$TARGET_DIR/$file"
done

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

echo "✅ Dotfiles installed and active."
