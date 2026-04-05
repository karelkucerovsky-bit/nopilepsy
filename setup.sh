#!/bin/bash
set -e

echo "=== Nopilepsy Project Setup ==="
echo ""

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "ERROR: Xcode is not installed. Install Xcode from the App Store first."
    exit 1
fi

echo "[1/3] Installing XcodeGen (if needed)..."
if ! command -v xcodegen &> /dev/null; then
    if command -v brew &> /dev/null; then
        brew install xcodegen
    else
        echo "Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install xcodegen
    fi
else
    echo "  XcodeGen already installed."
fi

echo "[2/3] Generating Xcode project..."
cd "$(dirname "$0")"
xcodegen generate

echo "[3/3] Opening in Xcode..."
open Nopilepsy.xcodeproj

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Select your Development Team in Xcode (Signing & Capabilities)"
echo "  2. Connect your iPhone + Apple Watch"
echo "  3. Select the 'Nopilepsy' scheme and hit Run"
echo ""
echo "NOTE: You need a paid Apple Developer account to run on a real"
echo "Apple Watch with HealthKit. The simulator works for UI testing."
