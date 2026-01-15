#==============================================================================
# Build Targets
#==============================================================================

.PHONY: build build-apk build-ios gen-icons

build: install ## Build the app (APK and iOS)
	@echo "🔨 Building..."
	@$(FLUTTER) build apk
	@$(FLUTTER) build ios --no-codesign
	@echo "✅ Build complete"

build-apk: install ## Build Android APK only
	@echo "🔨 Building APK..."
	@$(FLUTTER) build apk
	@echo "✅ APK built"

build-ios: install ## Build iOS only
	@echo "🔨 Building iOS..."
	@$(FLUTTER) build ios --no-codesign
	@echo "✅ iOS built"

gen-icons: ## Generate app icons
	@echo "🎨 Generating app icons..."
	@$(DART) run flutter_launcher_icons
	@echo "✅ Icons generated"
