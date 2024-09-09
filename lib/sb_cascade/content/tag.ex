defmodule SbCascade.Content.Tag do
  @moduledoc """
  The Tag schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(name slug)a
  @optional_fields []
  @all_fields @required_fields ++ @optional_fields

  @derive {Flop.Schema, filterable: [:name], sortable: [:name, :inserted_at]}

  schema "tags" do
    field :name, :string
    field :slug, :string

    many_to_many :comics, SbCascade.Content.Comic, join_through: "comic_tags"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
