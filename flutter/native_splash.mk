# Check which tools are available
DART_EXISTS := $(shell command -v $(DART) 2>/dev/null)

# Define Dart-based targets only if Dart exists
ifdef DART_EXISTS
.PHONY: splash

splash: ## Regenerate native splash screen assets
	@echo "🌅 Regenerating native splash screen assets..."
	@$(DART) run flutter_native_splash:create
	@echo "✅ Native splash screen assets regenerated"
endif