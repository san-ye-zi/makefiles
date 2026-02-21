#==============================================================================
# Build Targets
#==============================================================================

# Check which tools are available
FLUTTER_EXISTS := $(shell command -v $(FLUTTER) 2>/dev/null)

# Define Flutter-based targets only if Flutter exists
ifdef FLUTTER_EXISTS
.PHONY: build-apk-dev-secrets build-apk-staging-secrets build-apk-prod-secrets build-appbundle-prod-secrets build-ios-dev-secrets build-ios-staging-secrets build-ios-prod-secrets

# Android APK
build-apk-dev-secrets:
	@echo "🔨 Building DEVELOPMENT APK with secrets..."
	@$(FLUTTER) build apk $(DEV_DEFINES) $(SECRETS_DEFINES) --debug

build-apk-staging-secrets:
	@echo "🔨 Building STAGING APK with secrets..."
	@$(FLUTTER) build apk $(STAGING_DEFINES) $(SECRETS_DEFINES) --profile

build-apk-prod-secrets:
	@echo "🔨 Building PRODUCTION APK with secrets..."
	@$(FLUTTER) build apk $(PROD_DEFINES) $(SECRETS_DEFINES) --release

build-appbundle-prod-secrets:
	@echo "🔨 Building PRODUCTION App Bundle with secrets..."
	@$(FLUTTER) build appbundle $(PROD_DEFINES) $(SECRETS_DEFINES) --release

# iOS
build-ios-dev-secrets: ## Build iOS development with secrets
	@echo "🔨 Building DEVELOPMENT iOS with secrets..."
	@$(FLUTTER) build ios $(DEV_DEFINES) $(SECRETS_DEFINES) --debug --no-codesign

build-ios-staging-secrets: ## Build iOS staging with secrets
	@echo "🔨 Building STAGING iOS with secrets..."
	@$(FLUTTER) build ios $(STAGING_DEFINES) $(SECRETS_DEFINES) --profile --no-codesign

build-ios-prod-secrets: ## Build iOS production with secrets
	@echo "🔨 Building PRODUCTION iOS with secrets..."
	@$(FLUTTER) build ios $(PROD_DEFINES) $(SECRETS_DEFINES) --release --no-codesign
