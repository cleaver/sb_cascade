defmodule SbCascadeWeb.Api.TagJSON do
  @moduledoc """
  Format JSON for tags.
  """
  alias SbCascadeWeb.Api.ComicJSON
  alias SbCascade.Content.Tag

  @doc """
  Renders a list of tags.
  """
  def index(%{tags: tags}) do
    %{data: for(tag <- tags, do: data(tag))}
  end

  @doc """
  Renders a single tag.
  """
  def show(%{tag: tag}) do
    %{data: data(tag)}
  end

  @doc """
  Formats a list of tags for JSON.
  """
  def list_data(tags) when is_list(tags), do: for(tag <- tags, do: data(tag))
  def list_data(%Ecto.Association.NotLoaded{} = _tags), do: "not loaded"
  def list_data(_), do: []

  @doc """
  Formats a tag record for JSON.
  """
  def data(%Tag{} = tag) do
    %{
      id: tag.id,
      comics: tag.comics |> ComicJSON.list_data(),
      name: tag.name,
      slug: tag.slug
    }
  end

  def data(column) when is_binary(column), do: column
end
