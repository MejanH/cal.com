# Cal.com Development Makefile
# Most frequently used commands: setup, dev-frontend, dev-backend

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
	@echo "🎉 Setup complete! Now run 'make dev-frontend' and 'make dev-backend' in separate terminals"

# Frontend development server
dev-frontend:
	@echo "🌐 Starting frontend development server..."
	yarn workspace @calcom/web start

# Backend development server  
dev-backend:
	@echo "⚙️  Starting backend development server..."
	yarn workspace @calcom/api-v2 start

# =============================================================================
# BUILD COMMANDS (used less frequently)
# =============================================================================

# Build all frontend components
build-frontend:
	@echo "🔨 Building frontend components..."
	yarn workspace @calcom/trpc run build
	@echo "✅ TRPC build complete"
	yarn workspace @calcom/embed-core run build
	@echo "✅ Embed-core build complete"
	yarn workspace @calcom/web run build
	@echo "✅ Web build complete"
	@echo "🎉 Frontend build complete!"

# Build backend
build-backend:
	@echo "🔨 Building backend..."
	yarn workspace @calcom/api-v2 build
	@echo "✅ Backend build complete!"

# Build everything
build-all: build-frontend build-backend
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
	@echo "  make setup        - Setup docker services (run first)"
	@echo "  make dev-frontend - Start frontend dev server (separate terminal)"
	@echo "  make dev-backend  - Start backend dev server (separate terminal)"
	@echo ""
	@echo "🔨 BUILD COMMANDS:"
	@echo "  make build-frontend - Build all frontend components"
	@echo "  make build-backend  - Build backend"
	@echo "  make build-all      - Build everything"
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
.PHONY: setup dev-frontend dev-backend build-frontend build-backend build-all restart-docker clean-docker clean-prisma clean-emails clean-api help