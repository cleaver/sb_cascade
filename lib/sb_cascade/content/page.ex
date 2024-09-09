defmodule SbCascade.Content.Page do
  @moduledoc """
  The Page schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SbCascade.Content.File

  @required_fields ~w(title body slug meta_description image_alt_text)a
  @optional_fields ~w(media_id)a
  @all_fields @required_fields ++ @optional_fields

  @derive {
    Flop.Schema,
    filterable: [:title], sortable: [:title]
  }

  schema "pages" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :meta_description, :string
    field :image_alt_text, :string

    belongs_to :media, File, on_replace: :update

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:media)
  end
end
