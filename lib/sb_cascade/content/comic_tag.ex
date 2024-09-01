defmodule SbCascade.Content.ComicTag do
  @moduledoc """
  A comic_tag associates a tag with a comic.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "comic_tags" do
    field :ordinal, :integer
    belongs_to :comic, SbCascade.Content.Comic, primary_key: true
    belongs_to :tag, SbCascade.Content.Tag, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comic_tag, attrs, ordinal) do
    comic_tag
    |> cast(attrs, [:comic_id, :tag_id])
    |> change(ordinal: ordinal)
    # |> validate_required([:comic_id, :ordinal, :tag_id])
    |> unique_constraint([:comic, :tag], name: :comic_tag_comic_id_tag_id_index)
  end
end
