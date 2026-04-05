# Nopilepsy Makefile — run on macOS only
# Usage: make setup && make build

.PHONY: setup generate build build-watch test clean

# One-time setup: install XcodeGen and generate project
setup:
	@command -v xcodegen >/dev/null 2>&1 || brew install xcodegen
	@xcodegen generate
	@echo "Project generated. Run: make build"

# Regenerate project after file changes
generate:
	xcodegen generate

# Build iPhone app for simulator
build:
	xcodebuild build \
		-project Nopilepsy.xcodeproj \
		-scheme Nopilepsy \
		-destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest' \
		-configuration Debug \
		CODE_SIGNING_ALLOWED=NO

# Build Watch app for simulator
build-watch:
	xcodebuild build \
		-project Nopilepsy.xcodeproj \
		-scheme NopiWatch \
		-destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm),OS=latest' \
		-configuration Debug \
		CODE_SIGNING_ALLOWED=NO

# Run unit tests
test:
	cd NopiCore && swift test

# Run all tests including UI
test-all:
	xcodebuild test \
		-project Nopilepsy.xcodeproj \
		-scheme Nopilepsy \
		-destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest' \
		-configuration Debug \
		CODE_SIGNING_ALLOWED=NO

# Open in Xcode
open:
	@test -f Nopilepsy.xcodeproj/project.pbxproj || (echo "Run 'make setup' first" && exit 1)
	open Nopilepsy.xcodeproj

# Clean build artifacts
clean:
	xcodebuild clean -project Nopilepsy.xcodeproj -scheme Nopilepsy 2>/dev/null || true
	xcodebuild clean -project Nopilepsy.xcodeproj -scheme NopiWatch 2>/dev/null || true
	rm -rf DerivedData
	cd NopiCore && swift package clean
