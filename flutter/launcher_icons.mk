# Check which tools are available
DART_EXISTS := $(shell command -v $(DART) 2>/dev/null)

# Define Dart-based targets only if Dart exists
ifdef DART_EXISTS
.PHONY: icons

icons: ## Generate app icons
	@echo "🎨 Generating app icons..."
	@$(DART) run flutter_launcher_icons
	@echo "✅ Icons generated"
endif
