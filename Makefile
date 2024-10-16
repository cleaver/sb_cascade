# Makefile for building Docker images

# Default target: print available commands
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make build-testdb  - Build the database Docker image"
	@echo "  make build-testex  - Build the Elixir Docker image"
	@echo "  make build         - Build both Docker images"
	@echo "  make test-start    - Start e2e test environment"
	@echo "  make test-stop     - Stop e2e test environment"

# Build the database Docker image
.PHONY: build-testdb
build-testdb:
	docker build -t ghcr.io/cleaver/sb_cascade/sb_dbe2e:latest -f Dockerfile.test.pgsql .

# Build the Elixir Docker image
.PHONY: build-testex
build-testex:
	docker build -t ghcr.io/cleaver/sb_cascade/sb_exe2e:latest -f Dockerfile.test.elixir .

# Build both Docker images
.PHONY: build
build: build-testdb build-testex

# Run e2e test environment using Docker Compose
.PHONY: test-start
test-start:
	docker compose -f ./docker-compose.test.yml up -d

.PHONY: test-stop
test-stop:
	docker compose -f ./docker-compose.test.yml down

