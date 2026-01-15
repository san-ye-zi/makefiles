#==============================================================================
# Development Targets
#==============================================================================

# Check which tools are available
FLUTTER_EXISTS := $(shell command -v $(FLUTTER) 2>/dev/null)

# Define Flutter-based targets only if Flutter exists
ifdef FLUTTER_EXISTS
.PHONY: install clean run dev outdated upgrade upgrade-major run-device

install: ## Install dependencies
	@echo "📦 Installing dependencies..."
	@$(FLUTTER) pub get
	@echo "✅ Dependencies installed"

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	@$(FLUTTER) clean
	@$(FLUTTER) pub get
	@echo "✅ Clean complete"

run: ## Run the app
	@$(FLUTTER) run

dev: ## Run in debug mode with hot reload
	@$(FLUTTER) run --debug

outdated: ## Check for outdated dependencies
	@$(FLUTTER) pub outdated

upgrade: ## Upgrade dependencies (respect constraints)
	@echo "⬆️  Upgrading dependencies..."
	@$(FLUTTER) pub upgrade
	@echo "✅ Dependencies upgraded"

upgrade-major: ## Upgrade to latest major versions (interactive)
	@$(FLUTTER) pub upgrade --major-versions

run-device: ## Run on specific device
	@echo "Available devices:"
	@$(FLUTTER) devices
	@read -p "Enter device ID: " device_id; \
	$(FLUTTER) run -d $$device_id
endif