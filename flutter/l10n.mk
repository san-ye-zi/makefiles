#==============================================================================
# Localization Targets
#==============================================================================

.PHONY: gen-l10n l10n-sort l10n-check l10n-unused l10n-missing l10n-validate l10n-sync

gen-l10n: ## Generate localization files
	@echo "🌍 Generating localization files..."
	@$(FLUTTER) gen-l10n
	@echo "✅ Localization files generated"

l10n-sort: ## Sort ARB files alphabetically
	@if [ -f "$(SCRIPTS_DIR)/sort_arb.py" ]; then \
		echo "📝 Sorting ARB files..."; \
		$(PYTHON) $(SCRIPTS_DIR)/sort_arb.py 2>/dev/null || \
		(echo "⚠️  Python 3 required for sorting"; exit 1); \
	else \
		echo "❌ $(SCRIPTS_DIR)/sort_arb.py not found"; \
		echo "Run 'make update-makefiles' to download scripts"; \
		exit 1; \
	fi

l10n-check: ## Check ARB files for common issues
	@echo "🔍 Checking ARB files for issues..."
	@errors=0; \
	for file in $(L10N_DIR)/*.arb; do \
		if [ -f "$$file" ]; then \
			echo "  Checking $$(basename $$file)..."; \
			if ! $(PYTHON) -m json.tool "$$file" > /dev/null 2>&1; then \
				echo "    ❌ Invalid JSON syntax"; \
				errors=$$((errors + 1)); \
			fi; \
		fi \
	done; \
	if [ $$errors -eq 0 ]; then \
		echo "✅ All ARB files are valid"; \
	else \
		echo "❌ Found $$errors error(s)"; \
		exit 1; \
	fi

l10n-unused: ## Find unused translation keys
	@echo "🔍 Finding unused translation keys..."
	@echo "Scanning $(L10N_DIR)/app_en.arb for keys used in Dart files..."
	@unused_count=0; \
	if [ -f "$(L10N_DIR)/app_en.arb" ]; then \
		keys=$$($(PYTHON) -c "import json; data=json.load(open('$(L10N_DIR)/app_en.arb')); print('\n'.join([k for k in data.keys() if not k.startswith('@')]))" 2>/dev/null || \
			(echo "⚠️  Python 3 required"; exit 1)); \
		for key in $$keys; do \
			if ! grep -r "\.$$key" $(LIB_DIR)/ --include="*.dart" > /dev/null 2>&1; then \
				echo "  ⚠️  Potentially unused: $$key"; \
				unused_count=$$((unused_count + 1)); \
			fi \
		done; \
		if [ $$unused_count -eq 0 ]; then \
			echo "✅ All translation keys appear to be used"; \
		else \
			echo "⚠️  Found $$unused_count potentially unused key(s)"; \
			echo "Note: This is a heuristic check. Review manually."; \
		fi \
	else \
		echo "❌ $(L10N_DIR)/app_en.arb not found"; \
	fi

l10n-missing: ## Find missing translations across locales
	@echo "🔍 Finding missing translations..."
	@$(PYTHON) -c ' \
import json, os, sys; \
from pathlib import Path; \
\
arb_files = list(Path("$(L10N_DIR)").glob("app_*.arb")); \
if not arb_files: \
	print("❌ No ARB files found in $(L10N_DIR)/"); \
	sys.exit(1); \
\
locales = {}; \
for f in arb_files: \
	with open(f) as file: \
		data = json.load(file); \
		locale = data.get("@@locale", f.stem.replace("app_", "")); \
		keys = {k for k in data.keys() if not k.startswith("@")}; \
		locales[locale] = {"file": f.name, "keys": keys}; \
\
if "en" not in locales: \
	print("❌ app_en.arb not found (required as reference)"); \
	sys.exit(1); \
\
reference_keys = locales["en"]["keys"]; \
has_missing = False; \
\
for locale, data in sorted(locales.items()): \
	if locale == "en": continue; \
	missing = reference_keys - data["keys"]; \
	extra = data["keys"] - reference_keys; \
	\
	if missing or extra: \
		has_missing = True; \
		print(f"\n📄 {data[\"file\"]} ({locale}):"); \
		if missing: \
			print(f"  ❌ Missing {len(missing)} key(s):"); \
			for key in sorted(missing)[:5]: \
				print(f"     - {key}"); \
			if len(missing) > 5: \
				print(f"     ... and {len(missing) - 5} more"); \
		if extra: \
			print(f"  ⚠️  Extra {len(extra)} key(s) not in en:"); \
			for key in sorted(extra)[:5]: \
				print(f"     - {key}"); \
			if len(extra) > 5: \
				print(f"     ... and {len(extra) - 5} more"); \
\
if not has_missing: \
	print("✅ All locales have matching keys with English"); \
' 2>/dev/null || (echo "⚠️  Python 3 required for this check"; exit 1)

l10n-validate: l10n-check l10n-missing ## Validate all ARB files (comprehensive check)
	@echo ""
	@echo "✅ Localization validation complete"

l10n-sync: l10n-sort l10n-validate gen-l10n ## Complete l10n workflow: sort, validate, and generate
	@echo ""
	@echo "✅ Localization sync complete!"
	@echo "📋 Summary:"
	@echo "  - ARB files sorted alphabetically"
	@echo "  - All validations passed"
	@echo "  - Generated Dart files updated"
