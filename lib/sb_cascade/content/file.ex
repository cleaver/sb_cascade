defmodule SbCascade.Content.File do
  @moduledoc """
  The File schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Flop.Schema, filterable: [:name], sortable: [:name, :inserted_at]}

  schema "files" do
    field :name, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :url])
    |> validate_required([:name, :url])
  end
end
