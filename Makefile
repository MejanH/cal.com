# Cal.com Development Makefile
# Most frequently used commands: setup, start-web, start-api-v2

# =============================================================================
# FREQUENTLY USED COMMANDS
# =============================================================================

# Setup docker services (run this first, then start dev servers)
setup:
	@echo "🚀 Setting up docker services..."
	yarn workspace @calcom/prisma run dx
	@echo "✅ Prisma setup complete"
	yarn workspace @calcom/emails run dx
	@echo "✅ Emails setup complete"
	yarn workspace @calcom/api-v2 exec docker compose up -d
	@echo "✅ API v2 docker services started"
	@echo "🎉 Setup complete! Now run 'make start-web' and 'make start-api-v2' in separate terminals"

# Web start server
start-web:
	@echo "🌐 Starting web server..."
	yarn workspace @calcom/web start

# API v2 start server  
start-api-v2:
	@echo "⚙️  Starting API v2 server..."
	yarn workspace @calcom/api-v2 start

# Web development mode
dev-web:
	@echo "🌐 Starting web in development mode..."
	yarn dx

# API v2 development mode
dev-api-v2:
	@echo "⚙️  Starting API v2 in development mode..."
	yarn workspace @calcom/api-v2 dev

# =============================================================================
# BUILD COMMANDS (used less frequently)
# =============================================================================

# Clean and install dependencies
clean-install:
	@echo "🧹 Cleaning and installing dependencies..."
	-yarn clean
	yarn install
	@echo "✅ Clean and install complete!"

# Build web packages
build-web:
	@echo "🔨 Building web packages..."
	NODE_OPTIONS=--max-old-space-size=8192 yarn build
	@echo "✅ Web packages build complete!"

# Build API v2
build-api-v2:
	@echo "🔨 Building API v2..."
	yarn workspace @calcom/api-v2 build
	@echo "✅ API v2 build complete!"

# Build everything
build-all: build-web build-api-v2
	@echo "🎉 All builds complete!"

# =============================================================================
# UTILITY COMMANDS
# =============================================================================

# Quick restart of docker services
restart-docker:
	@echo "🔄 Restarting docker services..."
	yarn workspace @calcom/prisma exec docker compose down
	yarn workspace @calcom/emails exec docker compose down
	yarn workspace @calcom/api-v2 exec docker compose down
	@echo "✅ All containers stopped"
	yarn workspace @calcom/prisma run dx
	yarn workspace @calcom/emails run dx
	yarn workspace @calcom/api-v2 exec docker compose up -d
	@echo "✅ All docker services restarted"

# Clean all docker containers and volumes
clean-docker:
	@echo "🧹 Cleaning all docker containers and volumes..."
	yarn workspace @calcom/prisma run db-nuke
	@echo "✅ Prisma containers nuked"
	yarn workspace @calcom/emails exec docker compose down -v
	@echo "✅ Emails containers cleaned"
	yarn workspace @calcom/api-v2 exec docker compose down -v
	@echo "✅ API v2 containers cleaned"
	@echo "🎉 All docker containers and volumes cleaned!"

# Clean individual services
clean-prisma:
	@echo "🧹 Cleaning Prisma docker containers..."
	yarn workspace @calcom/prisma run db-nuke
	@echo "✅ Prisma containers nuked"

clean-emails:
	@echo "🧹 Cleaning Emails docker containers..."
	yarn workspace @calcom/emails exec docker compose down -v
	@echo "✅ Emails containers cleaned"

clean-api:
	@echo "🧹 Cleaning API v2 docker containers..."
	yarn workspace @calcom/api-v2 exec docker compose down -v
	@echo "✅ API v2 containers cleaned"

# Help command
help:
	@echo "📋 Available commands:"
	@echo ""
	@echo "🚀 FREQUENT COMMANDS:"
	@echo "  make setup      - Setup docker services (run first)"
	@echo "  make start-web  - Start web server (separate terminal)"
	@echo "  make start-api-v2 - Start API v2 server (separate terminal)"
	@echo "  make dev-web    - Start web in development mode (separate terminal)"
	@echo "  make dev-api-v2 - Start API v2 in development mode (separate terminal)"
	@echo ""
	@echo "🔨 BUILD COMMANDS:"
	@echo "  make clean-install - Clean and install dependencies"
	@echo "  make build-web     - Build web packages"
	@echo "  make build-api-v2  - Build API v2"
	@echo "  make build-all     - Build everything"
	@echo ""
	@echo "🛠️  UTILITY COMMANDS:"
	@echo "  make restart-docker - Restart all docker services"
	@echo "  make clean-docker   - Clean all docker containers and volumes"
	@echo "  make clean-prisma   - Clean only Prisma containers"
	@echo "  make clean-emails   - Clean only Emails containers"  
	@echo "  make clean-api      - Clean only API v2 containers"
	@echo "  make help          - Show this help"

# Default target
.DEFAULT_GOAL := help

# Declare phony targets
.PHONY: setup start-web start-api-v2 dev-web dev-api-v2 clean-install build-web build-api-v2 build-all restart-docker clean-docker clean-prisma clean-emails clean-api help