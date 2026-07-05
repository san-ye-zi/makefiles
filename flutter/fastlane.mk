#==============================================================================
# Fastlane Makefile for iOS and Android deployment
#==============================================================================

.PHONY: fastlane-install ios-beta ios-release ios-bump-build ios-bump-version ios-promote ios-metadata ios-screenshots ios-screenshots-iphone ios-screenshots-ipad ios-sync-certs ios-generate-certs android-beta android-release android-promote

# Login-shell wrapper. `make` recipes run in a bare, non-interactive /bin/sh
# that does NOT load the Ruby version manager (rvm/rbenv/asdf), so they inherit
# whatever Ruby the caller's terminal happens to have active. If that differs
# from the version pinned in ios/.ruby-version (and the Gemfile's `ruby` line),
# bundler aborts with "Your Ruby version is X, but your Gemfile specified Y".
# Running through a login shell re-activates the project Ruby before bundler
# runs, so these targets work regardless of the caller's active Ruby.
# Usage: @$(RUN) 'cd ios && bundle exec ...'  (single-quote outside the call so
# any inner double-quoted args, e.g. dart_defines:"...", are preserved).
RUN := bash -lc

fastlane-install: ## Install fastlane dependencies for iOS and Android
	@echo "📦 Installing Fastlane dependencies..."
	@$(RUN) 'cd ios && bundle install'
	@$(RUN) 'cd android && bundle install'
	@echo "✅ Fastlane dependencies installed!"

# IOS Fastlane Commands
ios-beta: ## Deploy iOS to TestFlight (test device IDs receive test ads)
	@echo "🚀 Deploying iOS to TestFlight..."
	@$(RUN) 'cd ios && bundle exec fastlane beta dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"'

ios-release: ## Deploy iOS to App Store
	@echo "🚀 Deploying iOS to App Store..."
	@$(RUN) 'cd ios && bundle exec fastlane release dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"'

ios-bump-build: ## Increment iOS build number
	@$(RUN) 'cd ios && bundle exec fastlane bump_build'

ios-bump-version: ## Increment iOS version (use TYPE=patch|minor|major)
	@$(RUN) 'cd ios && bundle exec fastlane bump_version type:$(or $(TYPE),patch)'

ios-promote: ## Promote tested TestFlight build to App Store without rebuilding (use BUILD=<number> to specify, omit for latest)
	@$(RUN) 'cd ios && bundle exec fastlane promote $(if $(BUILD),build_number:$(BUILD),)'

ios-metadata: ## Upload App Store metadata (descriptions, keywords, release notes) for all languages
	@echo "📝 Uploading metadata..."
	@$(RUN) 'cd ios && bundle exec fastlane upload_metadata'

ios-screenshots: ## Upload App Store screenshots for all languages (iPhone then iPad, one device family at a time)
	@echo "📸 Uploading screenshots..."
	@$(RUN) 'cd ios && bundle exec fastlane upload_screenshots'

ios-screenshots-iphone: ## Upload App Store iPhone screenshots for all languages
	@echo "📸 Uploading iPhone screenshots..."
	@$(RUN) 'cd ios && bundle exec fastlane upload_screenshots_iphone'

ios-screenshots-ipad: ## Upload App Store iPad screenshots for all languages
	@echo "📸 Uploading iPad screenshots..."
	@$(RUN) 'cd ios && bundle exec fastlane upload_screenshots_ipad'

ios-sync-certs: ## Sync iOS certificates using match
	@$(RUN) 'cd ios && bundle exec fastlane sync_certs'

ios-generate-certs: ## Generate new iOS certificates and provisioning profiles using match (first-time setup)
	@$(RUN) 'cd ios && bundle exec fastlane generate_certs'

# Android Fastlane Commands
android-beta: ## Deploy Android to Play Store internal track
	@echo "🚀 Deploying Android to internal track..."
	@$(RUN) 'cd android && bundle exec fastlane beta dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"'

android-release: ## Deploy Android to Play Store production
	@echo "🚀 Deploying Android to production..."
	@$(RUN) 'cd android && bundle exec fastlane release dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"'

android-promote: ## Promote Android from internal to production
	@$(RUN) 'cd android && bundle exec fastlane promote_to_production'
