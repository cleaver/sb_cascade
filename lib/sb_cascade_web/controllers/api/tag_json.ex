defmodule SbCascadeWeb.Api.TagJSON do
  @moduledoc """
  Format JSON for tags.
  """
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
  def list_data(tags), do: for(tag <- tags, do: data(tag))

  @doc """
  Formats a tag record for JSON.
  """
  def data(%Tag{} = tag) do
    %{
      id: tag.id,
      name: tag.name,
      slug: tag.slug
    }
  end
end
