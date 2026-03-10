#!/usr/bin/env bash
set -euo pipefail

# Script to manually update a package in the repository
# Usage: ./scripts/update-package.sh <package-name>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <package-name>"
    echo "Example: $0 notify-me"
    echo ""
    echo "Available packages:"
    ls -1 pkgs/
    exit 1
fi

PACKAGE_NAME="$1"
PACKAGE_DIR="pkgs/$PACKAGE_NAME"
PACKAGE_FILE="$PACKAGE_DIR/package.nix"

if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Error: Package file not found: $PACKAGE_FILE"
    exit 1
fi

# Extract current version, owner, and repo from package.nix
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_FILE" || echo "")
OWNER=$(grep -oP 'owner = "\K[^"]+' "$PACKAGE_FILE" || echo "")
REPO=$(grep -oP 'repo = "\K[^"]+' "$PACKAGE_FILE" || echo "")

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Error: Could not extract owner/repo from $PACKAGE_FILE"
    exit 1
fi

echo "Package: $PACKAGE_NAME"
echo "Current version: $CURRENT_VERSION"
echo "Repository: https://github.com/$OWNER/$REPO"
echo ""

# Get latest release from GitHub
echo "Fetching latest release from GitHub..."
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

LATEST_TAG=$(gh release view --repo "$OWNER/$REPO" --json tagName --jq '.tagName' 2>/dev/null || echo "")

if [ -z "$LATEST_TAG" ]; then
    echo "Error: No releases found for $OWNER/$REPO"
    exit 1
fi

LATEST_VERSION="${LATEST_TAG#v}"

echo "Latest version: $LATEST_VERSION"
echo "Latest tag: $LATEST_TAG"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo ""
    echo "✓ Package is already up to date!"
    exit 0
fi

echo ""
echo "Update available: $CURRENT_VERSION -> $LATEST_VERSION"
read -p "Do you want to update? (y/N) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Update cancelled"
    exit 0
fi

# Fetch archive and calculate hash
ARCHIVE_URL="https://github.com/$OWNER/$REPO/archive/refs/tags/$LATEST_TAG.tar.gz"
echo ""
echo "Fetching archive and calculating hash..."
HASH=$(nix-prefetch-url --unpack "$ARCHIVE_URL" 2>&1 | tail -1)
SRI_HASH=$(nix hash to-sri --type sha256 "$HASH")

echo "New hash: $SRI_HASH"
echo ""

# Update the package file
echo "Updating $PACKAGE_FILE..."
sed -i "s/version = \"[^\"]*\"/version = \"$LATEST_VERSION\"/" "$PACKAGE_FILE"
sed -i "s/rev = \"[^\"]*\"/rev = \"$LATEST_TAG\"/" "$PACKAGE_FILE"
sed -i "s/sha256 = \"[^\"]*\"/sha256 = \"$SRI_HASH\"/" "$PACKAGE_FILE"

echo "✓ Package file updated"
echo ""

# Try to build the package
echo "Building package to verify the update..."
if nix build ".#$PACKAGE_NAME" --print-build-logs; then
    echo ""
    echo "✓ Build successful!"
    echo ""
    echo "Changes made:"
    git diff "$PACKAGE_FILE"
    echo ""
    echo "To commit these changes, run:"
    echo "  git add $PACKAGE_FILE"
    echo "  git commit -m 'chore: update $PACKAGE_NAME to $LATEST_VERSION'"
else
    echo ""
    echo "✗ Build failed!"
    echo ""
    echo "Reverting changes..."
    git checkout "$PACKAGE_FILE"
    exit 1
fi
