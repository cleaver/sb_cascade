# SbCascade — Agent Guide

## Project topology

```
sorrowbacon.com / sbcms.pimpsmooth.com
  └─ nginx (on host via ansible)
       ├─ → :3000  sorrowbacon-next-ts/  (NextJS frontend)
       └─ → :4000  sb_cascade/           (Phoenix CMS API)
                       └─ postgres (container in same stack)
```

Three repos: `sb_cascade/` (Elixir CMS), `sorrowbacon-next-ts/` (NextJS site), `sb-site/` (deployment).

**CI pipeline**: Elixir CI → docker-build-latest → E2E Tests → build-prod-latest. Versioned images built on VERSION change.

**Deployment**: `sb-site/deploy.yml` (ansible) copies compose files, pulls versioned images from GHCR, restarts stack on `maxwell.cleaver.ca`.

**Current version**: `2.0.8` — both VERSION files must match before deploy.

## Elixir / Phoenix coding conventions

### General Elixir
- Lists: use `Enum.at(list, i)`, never `list[i]`
- Rebinding: always assign the result of `if`/`case`/`cond` — never rebind inside
- One module per file only
- Struct access: `my_struct.field`, never `changeset[:field]`
- Don't use `String.to_atom/1` on user input
- Predicate functions: end with `?`, never prefix with `is_`
- `Task.async_stream` for concurrent collection work (pass `timeout: :infinity` as needed)
- Dates/times: use Elixir stdlib `Time`/`Date`/`DateTime`/`Calendar`

### Phoenix
- LiveView templates always `<Layouts.app flash={@flash} ...>` wrapper
- `<.flash_group>` only in `layouts.ex` — never elsewhere
- Use `<.icon>` for hero icons, never Heroicons modules
- Use `<.input>` for form inputs
- Routes: `scope` provides an alias prefix — no manual aliasing
- Forms: always `assign(socket, form: to_form(changeset))` in LV, `<.form for={@form}>` in template
- Never access changeset directly in templates — always go through `@form[:field]`
- Form/button unique DOM IDs for test selectors

### LiveView streams
- Always use streams for collections: `stream(socket, :name, items)`
- Template parent: `id="name" phx-update="stream"`, child: `:for={{id, item} <- @streams.name}`
- Filter/reset: refetch + `stream(socket, :name, items, reset: true)`
- Empty state: `<div class="hidden only:block">No items</div>` as sibling to the `:for`
- Toggle inside stream items: re-stream items alongside updated assign
- Never use deprecated `phx-update="append"` / `phx-update="prepend"`

### LiveView JS hooks
- Hooks with own DOM need `phx-update="ignore"`
- Colocated hooks: `<script :type={Phoenix.LiveView.ColocatedHook}>`, name prefixed with `.`
- External hooks: defined in `assets/js/`, passed to `LiveSocket` constructor
- Server→client: `push_event(socket, "event", %{...})` — always rebind socket
- Client→server with reply: `this.pushEvent("name", data, reply => ...)` / `handle_event("name", params, socket)`

### HEEx templates
- No inline `<script>` tags; no `<%= Enum.each %>` — always `<%= for ... do %>`
- Conditional classes: `class={["base", @flag && "extra", if(@cond, do: "a", else: "b")]}`
- Interpolation in attrs: `{@val}`, in bodies: `{@val}` or `<%= block %>`
- Code blocks inside `<pre>`/`<code>`: wrap tag with `phx-no-curly-interpolation`
- Comments: `<%!-- --%>`
- Use `<.link navigate={href}>` / `push_navigate`, never deprecated `live_redirect`/`live_patch`

### Ecto
- Preload associations accessed in templates
- Schema `:text` columns use `:string` type
- `validate_number` does not support `:allow_nil` — validations skip nil by default
- Access changeset fields via `Ecto.Changeset.get_field/2`
- Programmatic fields (e.g. `user_id`) not in `cast` — set explicitly on struct
- Generate migrations with `mix ecto.gen.migration name_with_underscores`

### Tests
- `start_supervised!/1` for process lifecycle
- No `Process.sleep/1` — use `Process.monitor` + `assert_receive {:DOWN, ...}` or `:sys.get_state/1`
- Use `element/2`, `has_element/2` from `Phoenix.LiveViewTest` — never match raw HTML
- Use `LazyHTML` for debug inspection of rendered output

### Mix
- `mix precommit` before pushing: compile, deps, format, credo, test
- `mix test --failed` to re-run only failures
- Avoid `mix deps.clean --all`

---

## Project artifacts

### Infrastructure & Build

| Artifact | Purpose |
|---|---|
| `Dockerfile` | Prod multi-stage Docker build |
| `Dockerfile.test.elixir` | E2E test runner image |
| `Dockerfile.test.pgsql` | E2E test DB with seed data |
| `docker-compose.test.yml` | E2E test stack definition |
| `docker_test/sb_cascade_e2e.sql` | Postgres seed dump for e2e tests |
| `Makefile` | `make build/test-start/test-stop` |
| `mix.exs` | Mix project, aliases (`setup`, `test`, `precommit`, `assets.deploy`) |

### CI

| File | Purpose |
|---|---|
| `.github/workflows/elixir.yml` | Unit tests, credo, formatting on push/PR |
| `.github/workflows/docker-build-latest.yml` | Builds `sb_prod:latest` after tests pass |
| `.github/workflows/docker-build-prod.yml` | Versioned build on VERSION change |
| `.github/workflows/docker-build-db.yml` | E2E DB test image build |
| `.github/workflows/docker-build-ex.yml` | E2E Elixir test image build |
| `.github/workflows/purge-images.yml` | Weekly GHCR untagged image cleanup |

### Config

| File | Purpose |
|---|---|
| `config/config.exs` | App config |
| `config/prod.exs` | Prod config (used in Docker) |
| `config/test.exs` | Test config |
| `config/runtime.exs` | Runtime env-var overrides |
| `VERSION` | Current release version |
| `.dockerignore` | Docker build context exclusions |

### Key Source Directories

| Path | Purpose |
|---|---|
| `lib/sb_cascade/` | Core app logic (schemas, contexts) |
| `lib/sb_cascade_web/` | Phoenix web layer (controllers, live views, templates) |
| `test/` | ExUnit tests |
| `priv/repo/migrations/` | Ecto migrations |
| `assets/` | JS/CSS (esbuild + Tailwind) |
| `rel/` | Release config |

### Current Version

`2.0.8` (matches `sorrowbacon-next-ts/VERSION`)