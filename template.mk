.PHONY: help update-makefiles
.DEFAULT_GOAL := help

#==============================================================================
# Configuration
#==============================================================================

MAKEFILES_REPO    := https://raw.githubusercontent.com/san-ye-zi/makefiles/main
MAKEFILES_DIR     := .make
# Use relative paths from the repo root
REMOTE_RESOURCES  := \
  config.mk \
  dev.mk \
  test.mk \
  build.mk \
  quality.mk \
  l10n.mk \
  scripts/sort_arb.py

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

#==============================================================================
# Help & Custom Targets
#==============================================================================

help: ## Show this help message
	@echo "🎯 Available commands:"
	@echo ""
	@awk ' \
		BEGIN {FS = ":.*?## "} \
		/^[a-zA-Z_-]+:.*?## / { \
			helpMessage = $$2; \
			if (helpMessage) { \
				printf "  \033[36m%-25s\033[0m %s\n", $$1, helpMessage; \
			} \
		} \
	' $(MAKEFILE_LIST) | sort
	@echo ""

welcome: ## Display welcome message
	@echo "👋 Welcome to makefiles!"
