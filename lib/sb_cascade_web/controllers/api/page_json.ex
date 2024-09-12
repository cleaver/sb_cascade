defmodule SbCascadeWeb.Api.PageJSON do
  @moduledoc """
  Format JSON for pages.
  """
  alias SbCascade.Content.Page
  alias SbCascadeWeb.Api.FileJSON

  @doc """
  Renders a list of pages.
  """
  def index(%{pages: pages}) do
    %{data: for(page <- pages, do: data(page))}
  end

  @doc """
  Renders a single page.
  """
  def show(%{page: page}) do
    %{data: data(page)}
  end

  @doc """
  Formats a list of pages for JSON.
  """
  def list_data(pages) when is_list(pages), do: for(page <- pages, do: data(page))
  def list_data(_), do: []

  @doc """
  Formats a page record for JSON.
  """
  def data(%Page{} = page) do
    %{
      id: page.id,
      title: page.title,
      body: page.body,
      slug: page.slug,
      media: FileJSON.data(page.media),
      meta_description: page.meta_description,
      image_alt_text: page.image_alt_text
    }
  end

  def data(column) when is_binary(column), do: column
end
