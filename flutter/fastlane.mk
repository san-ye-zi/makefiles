#==============================================================================
# Fastlane Commands
#==============================================================================

fastlane-install: ## Install fastlane dependencies for iOS and Android
	@echo "📦 Installing Fastlane dependencies..."
	@cd ios && bundle install
	@cd android && bundle install
	@echo "✅ Fastlane dependencies installed!"

# iOS Fastlane Commands
ios-beta: ## Deploy iOS to TestFlight
	@echo "🚀 Deploying iOS to TestFlight..."
	@cd ios && bundle exec fastlane beta dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

ios-release: ## Deploy iOS to App Store
	@echo "🚀 Deploying iOS to App Store..."
	@cd ios && bundle exec fastlane release dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

ios-bump-build: ## Increment iOS build number
	@cd ios && bundle exec fastlane bump_build

ios-bump-version: ## Increment iOS version (use TYPE=patch|minor|major)
	@cd ios && bundle exec fastlane bump_version type:$(or $(TYPE),patch)

ios-sync-certs: ## Sync iOS certificates using match
	@cd ios && bundle exec fastlane sync_certs

# Android Fastlane Commands
android-beta: ## Deploy Android to Play Store internal track
	@echo "🚀 Deploying Android to internal track..."
	@cd android && bundle exec fastlane beta dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

android-release: ## Deploy Android to Play Store production
	@echo "🚀 Deploying Android to production..."
	@cd android && bundle exec fastlane release dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

android-promote: ## Promote Android from internal to production
	@cd android && bundle exec fastlane promote_to_production
