defmodule SbCascade.Content.Comic do
  @moduledoc """
  The Comic schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SbCascade.Content.ComicTag

  @required_fields ~w(title body slug published post_date meta_description image_alt_text)a
  @optional_fields ~w(user_id)a
  @all_fields @required_fields ++ @optional_fields

  @derive {
    Flop.Schema,
    filterable: [:title, :body], sortable: [:title, :body, :post_date]
  }

  schema "comics" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :published, :boolean, default: false
    field :post_date, :date
    field :meta_description, :string
    field :image_alt_text, :string
    field :user_id, :id

    has_many :comic_tags, ComicTag,
      preload_order: [asc: :ordinal],
      on_replace: :delete

    has_many :tags, through: [:comic_tags, :tag]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comic, attrs) do
    comic
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:comic_tags,
      with: &ComicTag.changeset/3,
      sort_param: :tags_order,
      drop_param: :tags_delete
    )
  end
end
