#!/bin/sh
set -eu

cd -P -- "$(dirname -- "$0")"

# Run database migrations
# Idempotent — Ecto.Migrator skips already-run migrations
./migrate

# Start the Phoenix server
exec ./server