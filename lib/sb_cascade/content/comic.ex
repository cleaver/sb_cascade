defmodule SbCascade.Content.Comic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comics" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :published, :boolean, default: false
    field :post_date, :date
    field :meta_description, :string
    field :image_alt_text, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comic, attrs) do
    comic
    |> cast(attrs, [:title, :body, :slug, :published, :post_date, :meta_description, :image_alt_text])
    |> validate_required([:title, :body, :slug, :published, :post_date, :meta_description, :image_alt_text])
  end
end
