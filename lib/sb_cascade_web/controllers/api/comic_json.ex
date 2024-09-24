defmodule SbCascadeWeb.Api.ComicJSON do
  @moduledoc """
  Format JSON for comics.
  """
  alias SbCascade.Content.Comic
  alias SbCascadeWeb.Api.FileJSON
  alias SbCascadeWeb.Api.TagJSON

  @doc """
  Renders a list of comics.
  """
  def index(%{comics: comics}) do
    %{data: for(comic <- comics, do: data(comic))}
  end

  @doc """
  Renders a single comic.
  """
  def show(%{comic: comic}) do
    %{data: data(comic)}
  end

  @doc """
  Formats a list of comics for JSON.
  """
  def list_data(comics) when is_list(comics), do: for(comic <- comics, do: data(comic))
  def list_data(_), do: []

  defp data(%Comic{} = comic) do
    %{
      body: comic.body,
      id: comic.id,
      image_alt_text: comic.image_alt_text,
      media_id: comic.media_id,
      media: FileJSON.data(comic.media),
      meta_description: comic.meta_description,
      post_date: comic.post_date,
      published: comic.published,
      slug: comic.slug,
      tags: TagJSON.list_data(comic.tags),
      title: comic.title
    }
  end

  defp data(column) when is_binary(column), do: column

  def count(%{count: count}) do
    %{data: %{count: count}}
  end
end
