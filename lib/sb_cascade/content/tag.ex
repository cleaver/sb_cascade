defmodule SbCascade.Content.Tag do
  @moduledoc """
  The Tag schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Flop.Schema, filterable: [:name], sortable: [:name, :inserted_at]}

  schema "tags" do
    field :name, :string

    many_to_many :comics, SbCascade.Content.Comic, join_through: "comic_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
