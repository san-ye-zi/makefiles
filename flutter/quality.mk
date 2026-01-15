#==============================================================================
# Code Quality Targets
#==============================================================================

.PHONY: analyze format format-check fix lint check

analyze: ## Analyze code
	@echo "🔍 Analyzing code..."
	@$(DART) analyze

format: ## Format code
	@echo "✨ Formatting code..."
	@$(DART) format $(LIB_DIR)/ $(TEST_DIR)/ -l $(LINE_LENGTH)
	@echo "✅ Code formatted"

format-check: ## Check if code is formatted
	@$(DART) format $(LIB_DIR)/ $(TEST_DIR)/ -l $(LINE_LENGTH) --set-exit-if-changed

fix: ## Auto-fix issues
	@echo "🔧 Auto-fixing issues..."
	@$(DART) fix --apply
	@echo "✅ Issues fixed"

lint: analyze format-check ## Run full lint check
	@echo "✅ Lint check passed"

check: lint test ## Run all checks before committing
	@echo ""
	@echo "✅ All checks passed! Ready to commit."
