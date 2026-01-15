#==============================================================================
# Testing Targets
#==============================================================================

.PHONY: test test-watch test-golden coverage

test: ## Run tests
	@echo "🧪 Running tests..."
	@$(FLUTTER) test

test-watch: ## Run tests in watch mode
	@$(FLUTTER) test --watch

test-golden: ## Update golden files
	@echo "🖼️  Updating golden files..."
	@$(FLUTTER) test --update-goldens
	@echo "✅ Golden files updated"

coverage: ## Generate test coverage
	@echo "📊 Generating coverage..."
	@$(FLUTTER) test --coverage
	@echo "✅ Coverage report: $(COVERAGE_DIR)/lcov.info"
