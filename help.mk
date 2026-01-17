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

help-verbose: ## Display help grouped by file
	@awk 'BEGIN {FS = ":.*?## "}; \
		/^[^[:space:]].*##/ { \
			if (prev_file != FILENAME) { \
				printf "\n\033[1;33m[%s]\033[0m\n", FILENAME; \
				prev_file = FILENAME \
			} \
			printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)

welcome: ## Display welcome message
	@echo "👋 Welcome to Makefiles!"
	@echo ""
	@echo "📝 Quick Start:"
	@echo "  1. make help-verbose"
