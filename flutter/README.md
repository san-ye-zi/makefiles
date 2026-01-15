# Flutter Makefiles

Modular makefiles for Flutter development workflows. Each file handles a specific aspect of development, making it easy to maintain and customize.

## Requirements

Before using these makefiles, ensure you have:

- **Flutter SDK** - Install from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Dart SDK** - Comes with Flutter
- **Python 3** - Required for localization tools (sort, validate ARB files)
- **Make** - Pre-installed on macOS/Linux, for Windows use WSL or install GNU Make

Verify your setup:

```bash
flutter --version
dart --version
python3 --version
make --version
```

## Files Overview

### `config.mk`
Configuration variables used across all makefiles.

**Default Settings:**
- `FLUTTER := flutter` - Flutter CLI command
- `DART := dart` - Dart CLI command  
- `PYTHON := python3` - Python interpreter
- `LINE_LENGTH := 80` - Code formatting line length
- `LIB_DIR := lib` - Source code directory
- `TEST_DIR := test` - Test directory
- `L10N_DIR := lib/l10n` - Localization files directory

**Customization:**
Override any setting in your main `Makefile` after including these files:

```makefile
include .make/flutter/config.mk
# ... other includes

# Custom overrides
LINE_LENGTH := 120
L10N_DIR := lib/i18n
```

### `dev.mk`
Development and dependency management commands.

**Commands:**
- `make install` - Install Flutter dependencies (`flutter pub get`)
- `make clean` - Clean build artifacts and reinstall dependencies
- `make run` - Run the app on default device
- `make dev` - Run in debug mode with hot reload
- `make outdated` - Check for outdated dependencies
- `make upgrade` - Upgrade dependencies (respects version constraints)
- `make upgrade-major` - Upgrade to latest major versions (interactive)
- `make run-device` - Select and run on specific device

**Common Workflows:**
```bash
# First time setup
make install

# Daily development
make dev

# After pulling changes
make clean

# Check for updates
make outdated
make upgrade
```

### `test.mk`
Testing and coverage commands.

**Commands:**
- `make test` - Run all tests
- `make test-watch` - Run tests in watch mode (re-runs on file changes)
- `make test-golden` - Update golden test files
- `make coverage` - Generate test coverage report

**Usage:**
```bash
# Run tests before committing
make test

# Active development with auto-rerun
make test-watch

# Update UI test baselines
make test-golden

# Check coverage
make coverage
# View report at coverage/lcov.info
```

### `build.mk`
Build commands for different platforms.

**Commands:**
- `make build` - Build both APK and iOS (runs `install` first)
- `make build-apk` - Build Android APK only
- `make build-ios` - Build iOS without code signing
- `make gen-icons` - Generate app icons using flutter_launcher_icons

**Usage:**
```bash
# Build for both platforms
make build

# Android only
make build-apk

# iOS only
make build-ios

# Regenerate launcher icons
make gen-icons
```

### `quality.mk`
Code quality and linting commands.

**Commands:**
- `make analyze` - Run Dart analyzer
- `make format` - Auto-format code
- `make format-check` - Check formatting without modifying files
- `make fix` - Auto-fix common issues
- `make lint` - Run full lint check (analyze + format-check)
- `make check` - Run all checks before committing (lint + test)

**Pre-commit Workflow:**
```bash
# Format and fix issues
make format
make fix

# Verify everything passes
make check
# Runs: analyze, format-check, and test
```

### `l10n.mk`
Localization (i18n/l10n) management commands.

**Commands:**
- `make gen-l10n` - Generate Dart localization files from ARB files
- `make l10n-sort` - Sort ARB files alphabetically
- `make l10n-check` - Validate ARB file JSON syntax
- `make l10n-unused` - Find potentially unused translation keys
- `make l10n-missing` - Find missing translations across locales
- `make l10n-validate` - Run comprehensive validation (check + missing)
- `make l10n-sync` - Complete workflow: sort, validate, and generate

**Requirements:**
- Python 3 for sorting and validation
- ARB files in `lib/l10n/` (or your configured `L10N_DIR`)
- `app_en.arb` as the reference locale

**Workflow:**
```bash
# After adding/modifying translations
make l10n-sync
# This will:
# 1. Sort all ARB files alphabetically
# 2. Validate JSON syntax
# 3. Check for missing translations
# 4. Generate Dart files

# Check for issues only
make l10n-validate

# Find unused keys
make l10n-unused
```

**ARB File Structure:**
The `sort_arb.py` script maintains this structure:
1. `@@locale` at the top
2. Translation keys alphabetically
3. Each key's `@metadata` immediately after the key

Example:
```json
{
  "@@locale": "en",
  "appTitle": "My App",
  "@appTitle": {
    "description": "Application title"
  },
  "welcome": "Welcome!",
  "@welcome": {
    "description": "Welcome message"
  }
}
```
