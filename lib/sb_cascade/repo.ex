defmodule SbCascade.Repo do
  use Ecto.Repo,
    otp_app: :sb_cascade,
    adapter: Ecto.Adapters.SQLite3
end
