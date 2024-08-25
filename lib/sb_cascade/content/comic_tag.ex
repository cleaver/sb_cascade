defmodule SbCascade.Content.ComicTag do
  @moduledoc """
  A comic_tag associates a tag with a comic.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(ordinal comic_id tag_id)a
  @optional_fields ~w()a
  @all_fields @required_fields ++ @optional_fields

  schema "comic_tags" do
    field :ordinal, :integer
    belongs_to :comic, SbCascade.Content.Comic
    belongs_to :tag, SbCascade.Content.Tag

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comic_tag, attrs) do
    comic_tag
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
