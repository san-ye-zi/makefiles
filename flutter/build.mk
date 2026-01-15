#==============================================================================
# Build Targets
#==============================================================================

# Check which tools are available
FLUTTER_EXISTS := $(shell command -v $(FLUTTER) 2>/dev/null)
DART_EXISTS := $(shell command -v $(DART) 2>/dev/null)

# Define Flutter-based targets only if Flutter exists
ifdef FLUTTER_EXISTS
.PHONY: build build-apk build-ios

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
endif

# Define Dart-based targets only if Dart exists
ifdef DART_EXISTS
.PHONY: gen-icons

gen-icons: ## Generate app icons
	@echo "🎨 Generating app icons..."
	@$(DART) run flutter_launcher_icons
	@echo "✅ Icons generated"
endif