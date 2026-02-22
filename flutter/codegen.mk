# Check which tools are available
DART_EXISTS := $(shell command -v $(DART) 2>/dev/null)

# Define Dart-based targets only if Dart exists
ifdef DART_EXISTS
.PHONY: codegen codegen-watch setup

#==============================================================================
#  Code Generation
#==============================================================================

codegen: ## Run Drift code generation (after changing table definitions)
	@$(DART) run build_runner build --delete-conflicting-outputs

codegen-watch: ## Watch for changes and regenerate Drift code
	@$(DART) run build_runner watch --delete-conflicting-outputs
endif
