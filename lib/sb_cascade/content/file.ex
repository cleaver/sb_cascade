defmodule SbCascade.Content.File do
  @moduledoc """
  The File schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Flop.Schema, filterable: [:name], sortable: [:name, :inserted_at]}

  schema "files" do
    field :name, :string
    field :width, :integer
    field :url, :string
    field :height, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :width, :height, :url])
    |> validate_required([:name, :width, :height, :url])
  end
end
