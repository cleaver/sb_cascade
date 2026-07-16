# List available recipes (default when run with no arguments)
[private]
default:
    @just --list

# Build the database Docker image
build-testdb:
    docker build -t ghcr.io/cleaver/sb_cascade/sb_dbe2e:latest -f Dockerfile.test.pgsql .

# Build the Elixir Docker image
build-testex:
    docker build -t ghcr.io/cleaver/sb_cascade/sb_exe2e:latest -f Dockerfile.test.elixir .

# Build both Docker images
build: build-testdb build-testex

# Start postgres + adminer from the test compose file for local dev
db-start:
    docker compose -f ./docker-compose.test.yml up -d db adminer

# Stop postgres + adminer
db-stop:
    docker compose -f ./docker-compose.test.yml down db adminer

# Alias for db-start
db-up: db-start

# Alias for db-stop
db-down: db-stop

# Copy sb_cascade_prod to sb_cascade_dev (creates dev DB if missing)
db-populate:
    docker compose -f ./docker-compose.test.yml exec -T db sh -c "createdb -U postgres sb_cascade_dev 2>/dev/null; pg_dump -U postgres sb_cascade_prod | psql -U postgres -d sb_cascade_dev"

# Run e2e test environment using Docker Compose
test-start:
    docker compose -f ./docker-compose.test.yml up -d

# Stop e2e test environment
test-stop:
    docker compose -f ./docker-compose.test.yml down

# Alias for test-start
test-up: test-start

# Alias for test-stop
test-down: test-stop