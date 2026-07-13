# SbCascade — Phoenix CMS API

Elixir/Phoenix CMS powering sorrowbacon.com. Serves a REST API consumed by the NextJS frontend and hosts the admin UI at `sbcms.pimpsmooth.com`.

## Development Workflows

### Developing the CMS (Elixir)

**Option A — Local (hot-reload + debugging)**

```bash
# Terminal 1 — Postgres (if not already running)
make db           # starts postgres container on port 5432
# (run again later with just `make db` to restart it)

# Terminal 1 — CMS server
mix setup        # deps.get + ecto.create + ecto.migrate + seeds + assets
iex -S mix phx.server   # starts on http://localhost:4000 with live reload + iex
```

**Option B — Containerized (prod-like, requires rebuild on code changes)**

```bash
make build-testex   # build sb_exe2e from local code
make test-start     # start stack
make test-stop      # tear down
```

See [Docker Build & Test](#docker-build--test-e2e) below for details.

Then point the NextJS frontend at it:

```bash
# Terminal 2 — NextJS (from ../sorrowbacon-next-ts/)
API_SERVER=http://localhost:4000 yarn dev
```

### Developing the NextJS frontend only

The CMS can be either local or containerized — doesn't matter. Default config falls back to `http://cascade:4000` (Docker service name), so override it:

```bash
# Terminal 1 — CMS (any of these):
mix phx.server                  # local Elixir
make build-testex && make test-start   # containerized (see Docker section)
pushd ../sb-site && make up && popd    # full production stack

# Terminal 2 — NextJS (from ../sorrowbacon-next-ts/)
API_SERVER=http://localhost:4000 yarn dev --turbo
```

## Docker Build & Test (E2E)

Rebuild and run the containerized test stack from your **local code**. This is how you test changes to `config/`, `lib/`, or `mix.exs` in a production-like environment.

### Quick reference

```bash
make db             # start postgres container for local dev (creates on first run, restarts after)
make db-stop        # stop the postgres container
make build-testdb   # build sb_dbe2e (Postgres with test seed data)
make build-testex   # build sb_exe2e (Elixir release from local code)
make build          # both of the above
make test-start     # docker compose -f docker-compose.test.yml up -d
make test-stop      # docker compose -f docker-compose.test.yml down
```

Typical local dev flow: `make db` then `iex -S mix phx.server`.
Typical containerized flow: `make build-testex && make test-start`.

**Important**: `make build-testex` builds the image locally and tags it as `ghcr.io/cleaver/sb_cascade/sb_exe2e:latest`. The `docker-compose.test.yml` uses this tag, so Docker will use your locally-built image instead of pulling from GHCR. Rebuild after any changes to `config/`, `lib/`, or `mix.exs`.

### Images

| Image | Dockerfile | Registry | Purpose |
|---|---|---|---|
| `sb_prod` | `Dockerfile` | `ghcr.io/cleaver/sb_cascade/sb_prod` | Production deployment |
| `sb_exe2e` | `Dockerfile.test.elixir` | `ghcr.io/cleaver/sb_cascade/sb_exe2e` | E2E test Elixir server |
| `sb_dbe2e` | `Dockerfile.test.pgsql` | `ghcr.io/cleaver/sb_cascade/sb_dbe2e` | E2E test DB with seed data |

## Prerequisites

- **Postgres** — local install or `docker run postgres:17` on port 5432
- **Elixir 1.17+ / OTP 27** — via `asdf` or your package manager
- **Node.js** — for asset compilation

## Quickstart (local dev)

## Tests

```bash
mix test                          # unit + integration (ExUnit)
make test-start                   # spin up e2e test stack (port 4000)
make test-stop                    # tear down
```

CI runs `mix compile --warnings-as-errors`, `mix format --check-formatted`, `mix test`, `mix credo --strict`.

## CI/CD (GitHub Actions — 6 workflows)

| Workflow | Trigger | What it does |
|---|---|---|
| `elixir.yml` | push/PR to main | Test suite, credo, formatting |
| `docker-build-latest.yml` | after Elixir CI passes | Build + push `sb_prod:latest` |
| `docker-build-prod.yml` | VERSION change on main | Build + push `sb_prod:<version>` |
| `docker-build-db.yml` | Dockerfile.test.pgsql change | Build + push `sb_dbe2e:latest` |
| `docker-build-ex.yml` | push to main | Build + push `sb_exe2e:latest` |
| `purge-images.yml` | weekly cron | Clean untagged GHCR images |

## Runtime Config

| Env var | Purpose |
|---|---|
| `DATABASE_URL` | Postgres connection string |
| `SECRET_KEY_BASE` | Phoenix secret |
| `PHX_HOST` | Hostname for URL generation |
| `ALLOW_REGISTRATION` | If set, users can self-register |
| `ALLOW_LOCAL_ORIGIN` | If set, prod image works on localhost |
| `PHX_HOST_NAME` | Host URL, e.g. `cms.myapp.com` |

## Key Files

| File | Purpose |
|---|---|
| `Dockerfile` | Multi-stage prod build (Elixir 1.17.2/OTP 27) |
| `docker-compose.test.yml` | E2E test stack (sb_exe2e + sb_dbe2e) |
| `docker_test/sb_cascade_e2e.sql` | Seeded test DB dump |
| `config/` | Phoenix config (dev/prod/test) |
| `lib/` | Application code |
| `test/` | ExUnit tests |
| `Makefile` | Docker build + test commands |
| `mix.exs` | Mix project definition & aliases |
| `.github/workflows/` | 6 CI/CD workflows |


## Runtime Configuration

Environment Variables:

- `ALLOW_REGISTRATION`: if set, new users can self-register.
- `ALLOW_LOCAL_ORIGIN`: if set, prod image can be run and accessed on localhost.
- `PHX_HOST_NAME`: the host URL, EG: `cms.myapp.com`.

## Register API User

No user interface exists for registering an API user. Use the following code to register a user:

```elixir
iex> {:ok, user} = Accounts.register_user(%{email: "api-user@cleaver.ca", password: Ecto.UUID.generate()})

{:ok,
 #SbCascade.Accounts.User<
   __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
   id: 2,
   email: "api-user@cleaver.ca",
   confirmed_at: nil,
   inserted_at: ~U[2024-09-18 21:48:39Z],
   updated_at: ~U[2024-09-18 21:48:39Z],
   ...
 >}

iex> {:ok, user} = user |> User.confirm_changeset() |> Repo.update()

{:ok,
 #SbCascade.Accounts.User<
   __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
   id: 2,
   email: "api-user@cleaver.ca",
   confirmed_at: ~U[2024-09-18 21:59:27Z],
   inserted_at: ~U[2024-09-18 21:48:39Z],
   updated_at: ~U[2024-09-18 21:59:27Z],
   ...
 >}

iex> token = user |> Accounts.create_user_api_token()

"your-api-token"
```

API token expires in 100 years. (IE: Not my problem.)