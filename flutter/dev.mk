#==============================================================================
# Development Targets
#==============================================================================

# Check which tools are available
FLUTTER_EXISTS := $(shell command -v $(FLUTTER) 2>/dev/null)

# Define Flutter-based targets only if Flutter exists
ifdef FLUTTER_EXISTS
.PHONY: install clean run dev dev-secrets dev-secrets-verbose echo-dev-secrets staging staging-secrets echo-staging-secrets prod prod-secrets echo-prod-secrets outdated upgrade upgrade-major run-device

install: ## Install dependencies
	@echo "📦 Installing dependencies..."
	@$(FLUTTER) pub get
	@echo "✅ Dependencies installed"

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	@$(FLUTTER) clean
	@$(FLUTTER) pub get
	@echo "✅ Clean complete"

# Development
dev: ## Run the app
	@echo "🚀 Running in DEVELOPMENT mode..."
	@$(FLUTTER) run $(DEV_DEFINES)

dev-secrets:
	@echo "🚀 Running in DEVELOPMENT mode with secrets..."
	@$(FLUTTER) run $(DEV_DEFINES) $(SECRETS_DEFINES)

dev-secrets-verbose:
	@echo "🚀 Running in DEVELOPMENT mode with secrets..."
	@$(FLUTTER) run $(DEV_DEFINES) $(SECRETS_DEFINES) -v

echo-dev-secrets:
	@echo "Echo DEVELOPMENT dart-defines with secrets:"
	@echo $(DEV_DEFINES) $(SECRETS_DEFINES)

# Staging
staging: ## Run the app in staging mode
	@echo "🚀 Running in STAGING mode..."
	@$(FLUTTER) run $(STAGING_DEFINES) --profile

staging-secrets:
	@echo "🚀 Running in STAGING mode with secrets..."
	@$(FLUTTER) run $(STAGING_DEFINES) $(SECRETS_DEFINES) --profile

echo-staging-secrets:
	@echo "Echo STAGING dart-defines with secrets:"
	@echo $(STAGING_DEFINES) $(SECRETS_DEFINES)

# Production
prod:
	@echo "🚀 Running in PRODUCTION mode..."
	@$(FLUTTER) run $(PROD_DEFINES) --release

prod-secrets:
	@echo "🚀 Running in PRODUCTION mode with secrets..."
	@$(FLUTTER) run $(PROD_DEFINES) $(SECRETS_DEFINES) --release

echo-prod-secrets:
	@echo "Echo PRODUCTION dart-defines with secrets:"
	@echo $(PROD_DEFINES) $(SECRETS_DEFINES)	

# Check for outdated dependencies
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