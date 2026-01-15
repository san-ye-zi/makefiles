# Makefiles

Reusable Makefiles - streamline your development workflow with a consistent set of commands across all your projects.

## Features

- **🚀 Auto-sync** - Automatically downloads and updates shared makefiles from GitHub
- **📦 Dependency Management** - Install, upgrade, and check outdated packages

## Installation

### Quick Start

1. Copy `template.mk` to your Flutter project as `Makefile`:

```bash
curl -sL https://raw.githubusercontent.com/san-ye-zi/makefiles/main/template.mk -o Makefile
```

2. Run any command - the Makefile will automatically download all required files:

```bash
make .make-init
```

That's it! All shared makefiles and scripts will be downloaded to `.make/` on first use.

## Usage

### Getting Help

```bash
make help
```

This displays all available commands with descriptions.

## Configuration

Default configuration values are set in `.make/config.mk`. You can override these in your project's `Makefile`:

```makefile
# In your Makefile, after the includes:
LINE_LENGTH := 120        # Change from default 80
L10N_DIR := lib/i18n      # Change from default lib/l10n
```

### Available Variables

- `FLUTTER` - Flutter command (default: `flutter`)
- `DART` - Dart command (default: `dart`)
- `PYTHON` - Python command (default: `python3`)
- `LIB_DIR` - Library directory (default: `lib`)
- `TEST_DIR` - Test directory (default: `test`)
- `COVERAGE_DIR` - Coverage output directory (default: `coverage`)
- `L10N_DIR` - Localization directory (default: `lib/l10n`)
- `LINE_LENGTH` - Line length for formatting (default: `80`)

## Updating Makefiles

To update to the latest version of the shared makefiles:

```bash
make update-makefiles
```

This will delete and re-download all files from the repository.

## Project Structure

After initialization, your project will have:

```
your-project/
├── Makefile              # Your project's Makefile (from template.mk)
├── .make/                # Downloaded shared makefiles (gitignored)
│   ├── config.mk
│   ├── dev.mk
│   ├── test.mk
│   ├── build.mk
│   ├── quality.mk
│   ├── l10n.mk
│   └── scripts/
│       └── sort_arb.py
└── .make-init            # Marker file (gitignored)
```

Add to your `.gitignore`:

```gitignore
# Makefiles cache
.make/
.make-init
```

## Adding Custom Targets

You can add project-specific targets to your `Makefile`:

```makefile
# At the end of your Makefile

.PHONY: custom-target

custom-target: ## My custom command
	@echo "Running custom logic..."
	@$(FLUTTER) pub run my_tool
```

### Downloads failing

If makefiles fail to download, check:
- Your internet connection
- That you can access GitHub
- The repository URL in your Makefile is correct

### Commands not working

Ensure you're running make from your project root directory where the Makefile is located.

## Contributing

Contributions are welcome! The shared makefiles are maintained at:
https://github.com/san-ye-zi/makefiles

## License

This project is provided as-is for use.

## Credits

Created to simplify development workflows across multiple projects.
