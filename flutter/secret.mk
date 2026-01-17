#==============================================================================
# Secrets Management
#==============================================================================

# Check if secrets file exists
SECRETS_FILE := .env.secrets.local
SECRETS_EXAMPLE_FILE := .env.secrets.example
SECRETS_EXISTS := $(shell test -f $(SECRETS_FILE) && echo 1 || echo 0)

# Load secrets from file if it exists
ifeq ($(SECRETS_EXISTS),1)
  include $(SECRETS_FILE)
  export
endif


#==============================================================================
# Secrets Setup Commands
#==============================================================================

secrets-setup: ## Setup local secrets file from template
	@if [ -f $(SECRETS_FILE) ]; then \
		echo "⚠️  $(SECRETS_FILE) already exists!"; \
		echo "   Delete it first if you want to recreate from template."; \
	else \
		cp $(SECRETS_EXAMPLE_FILE) $(SECRETS_FILE); \
		echo "✅ Created $(SECRETS_FILE) from template"; \
		echo ""; \
		echo "📝 Next steps:"; \
		echo "   1. Edit $(SECRETS_FILE) and add your real secrets"; \
		echo ""; \
		echo "⚠️  IMPORTANT: Never commit $(SECRETS_FILE) to git!"; \
	fi

secrets-check: ## Check if secrets are configured
	@echo "🔍 Checking secrets configuration..."
	@if [ ! -f $(SECRETS_FILE) ]; then \
		echo "❌ $(SECRETS_FILE) not found!"; \
		echo ""; \
		echo "Run: make secrets-setup"; \
		exit 1; \
	fi
	@echo "✅ Secrets file exists"
