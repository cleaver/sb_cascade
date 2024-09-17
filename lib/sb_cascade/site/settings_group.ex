defmodule SbCascade.Site.SettingsGroup do
  @moduledoc """
  Embedded schema for the site settings form.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(site_title meta_title meta_description)a
  @optional_fields ~w()a
  @all_fields @required_fields ++ @optional_fields

  @primary_key false
  embedded_schema do
    field :site_title, :string
    field :meta_title, :string
    field :meta_description, :string
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
