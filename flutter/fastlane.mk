#==============================================================================
# Fastlane Makefile for iOS and Android deployment
#==============================================================================

.PHONY: fastlane-install ios-beta ios-release ios-bump-build ios-bump-version ios-promote ios-metadata ios-screenshots ios-sync-certs ios-generate-certs android-beta android-release android-promote

fastlane-install: ## Install fastlane dependencies for iOS and Android
	@echo "📦 Installing Fastlane dependencies..."
	@cd ios && bundle install
	@cd android && bundle install
	@echo "✅ Fastlane dependencies installed!"

# IOS Fastlane Commands
ios-beta: ## Deploy iOS to TestFlight (test device IDs receive test ads)
	@echo "🚀 Deploying iOS to TestFlight..."
	@cd ios && bundle exec fastlane beta dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

ios-release: ## Deploy iOS to App Store
	@echo "🚀 Deploying iOS to App Store..."
	@cd ios && bundle exec fastlane release dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

ios-bump-build: ## Increment iOS build number
	@cd ios && bundle exec fastlane bump_build

ios-bump-version: ## Increment iOS version (use TYPE=patch|minor|major)
	@cd ios && bundle exec fastlane bump_version type:$(or $(TYPE),patch)

ios-promote: ## Promote tested TestFlight build to App Store without rebuilding (use BUILD=<number> to specify, omit for latest)
	@cd ios && bundle exec fastlane promote $(if $(BUILD),build_number:$(BUILD),)

ios-metadata: ## Upload App Store metadata (descriptions, keywords, release notes) for all languages
	@echo "📝 Uploading metadata..."
	@cd ios && bundle exec fastlane upload_metadata

ios-screenshots: ## Upload App Store screenshots for all languages
	@echo "📸 Uploading screenshots..."
	@cd ios && bundle exec fastlane upload_screenshots

ios-sync-certs: ## Sync iOS certificates using match
	@cd ios && bundle exec fastlane sync_certs

ios-generate-certs: ## Generate new iOS certificates and provisioning profiles using match (first-time setup)
	@cd ios && bundle exec fastlane generate_certs

# Android Fastlane Commands
android-beta: ## Deploy Android to Play Store internal track
	@echo "🚀 Deploying Android to internal track..."
	@cd android && bundle exec fastlane beta dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

android-release: ## Deploy Android to Play Store production
	@echo "🚀 Deploying Android to production..."
	@cd android && bundle exec fastlane release dart_defines:"$(PROD_DEFINES) $(SECRETS_DEFINES)"

android-promote: ## Promote Android from internal to production
	@cd android && bundle exec fastlane promote_to_production
