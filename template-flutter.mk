.PHONY: help update-makefiles
.DEFAULT_GOAL := help

#==============================================================================
# Secrets Management
#==============================================================================

# Check if secrets file exists
SECRETS_FILE := .env
SECRETS_EXAMPLE_FILE := .env.example
SECRETS_EXISTS := $(shell test -f $(SECRETS_FILE) && echo 1 || echo 0)

# Load secrets from file if it exists
ifeq ($(SECRETS_EXISTS),1)
  include $(SECRETS_FILE)
  export
endif

#==============================================================================
# Configuration
#==============================================================================

MAKEFILES_REPO    := https://raw.githubusercontent.com/san-ye-zi/makefiles/v1.0.0
MAKEFILES_DIR     := .make

# Use relative paths from the repo root
REMOTE_RESOURCES  := \
  config.mk \
	help.mk \
	flutter/secret.mk \
  flutter/dev.mk \
  flutter/test.mk \
  flutter/build.mk \
  flutter/quality.mk \
  flutter/l10n.mk \
	flutter/launcher_icons.mk \
	flutter/native_splash.mk \
	flutter/codegen.mk \
	flutter/fastlane.mk \
  flutter/scripts/sort_arb.py

#==============================================================================
# Secrets Management
#==============================================================================

# Build dart-define flags for all secrets
SECRETS_DEFINES := \
	--dart-define=TEST_SECRET=$(TEST_SECRET) \
	--dart-define=TEST_SECRET_2=$(TEST_SECRET_2)


#==============================================================================
# Environment Dart Defines
#==============================================================================

# Development dart-defines
DEV_DEFINES := \
	--dart-define=ENVIRONMENT=development \
	--dart-define=ENABLE_ADS=true

# Staging dart-defines
STAGING_DEFINES := \
	--dart-define=ENVIRONMENT=staging \
	--dart-define=ENABLE_ADS=false

# Production dart-defines
PROD_DEFINES := \
	--dart-define=ENVIRONMENT=production \
	--dart-define=ENABLE_ADS=true

#==============================================================================
# Auto-download Logic
#==============================================================================

# Internal target to ensure the environment is ready
.make-init:
	@echo "🚀 Synchronizing shared makefiles..."
	@mkdir -p $(MAKEFILES_DIR)
	@for path in $(REMOTE_RESOURCES); do \
		dest="$(MAKEFILES_DIR)/$$path"; \
		mkdir -p $$(dirname $$dest); \
		if [ ! -f "$$dest" ]; then \
			echo "📥 Downloading $$path..."; \
			curl -sL "$(MAKEFILES_REPO)/$$path" -o "$$dest" || { echo "❌ Failed to download $$path"; exit 1; }; \
			if [[ $$path == scripts/* ]]; then chmod +x "$$dest"; fi; \
		fi; \
	done
	@touch .make-init
	@echo "✅ All resources synced!"

update-makefiles: ## Force update all shared makefiles and scripts
	@echo "🔄 Refreshing local cache..."
	@rm -rf $(MAKEFILES_DIR)
	@rm -f .make-init
	@$(MAKE) .make-init

#==============================================================================
# Dynamic Inclusion
#==============================================================================

# 1. Trigger the download if .make-init doesn't exist
-include .make-init

# Always include config first (if it exists)
-include $(MAKEFILES_DIR)/config.mk

# 2. Include all downloaded .mk files recursively
# This avoids having to manually list every file twice
SHARED_MK_FILES := $(shell \
	find $(MAKEFILES_DIR) -name "*.mk" ! -name "config.mk" 2>/dev/null \
)
include $(SHARED_MK_FILES)
