defmodule SbCascadeWeb.Api.ComicController do
  @moduledoc """
  API controller for comics.
  """

  use SbCascadeWeb, :controller

  import SbCascadeWeb.Helpers.Api

  alias SbCascade.Content
  alias SbCascadeWeb.Api.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    comics = Content.list_comics_preloaded()
    render(conn, :index, comics: comics)
  end

  def show(conn, %{"slug" => slug}) do
    with {:ok, comic} <- Content.get_comic_by_slug(slug) |> nil_is_not_found() do
      render(conn, :show, comic: comic)
    end
  end
end
