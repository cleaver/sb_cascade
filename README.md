# SbCascade — Phoenix CMS API

Elixir/Phoenix CMS powering sorrowbacon.com. Serves a REST API consumed by the NextJS frontend and hosts the admin UI at `sbcms.pimpsmooth.com`.

## Quickstart (local dev)

```bash
mix setup        # deps.get + ecto.setup + assets.setup + assets.build
mix phx.server   # starts on :4000
```

Requires a local Postgres instance. Set `DATABASE_URL` in config or use defaults.

## Docker

| Image | Dockerfile | Registry |
|---|---|---|
| `sb_prod` | `Dockerfile` | `ghcr.io/cleaver/sb_cascade/sb_prod` |
| `sb_exe2e` | `Dockerfile.test.elixir` | `ghcr.io/cleaver/sb_cascade/sb_exe2e` |
| `sb_dbe2e` | `Dockerfile.test.pgsql` | `ghcr.io/cleaver/sb_cascade/sb_dbe2e` |

```bash
make build-testdb   # build sb_dbe2e
make build-testex   # build sb_exe2e
make build          # both
make test-start     # docker compose -f docker-compose.test.yml up -d
make test-stop      # docker compose -f docker-compose.test.yml down
```

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