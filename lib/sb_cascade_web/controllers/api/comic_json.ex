defmodule SbCascadeWeb.Api.ComicJSON do
  @moduledoc """
  Format JSON for comics.
  """
  alias SbCascadeWeb.Api.TagJSON
  alias SbCascadeWeb.Api.FileJSON
  alias SbCascade.Content.Comic

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
end
