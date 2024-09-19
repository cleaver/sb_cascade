# SbCascade

## Todo:

- [x] Authentication
  - [ ] API keys
- [x] Data model
  - [x] Unique constraints on slugs
- [x] Usability
  - [x] `slug` fields should be auto-generated

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
