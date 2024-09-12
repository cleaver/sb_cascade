defmodule SbCascadeWeb.Api.PageController do
  @moduledoc """
  API controller for pages.
  """

  use SbCascadeWeb, :controller

  import SbCascadeWeb.Helpers.Api

  alias SbCascade.Content
  alias SbCascadeWeb.Api.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    pages = Content.list_pages()
    render(conn, :index, pages: pages)
  end

  def show(conn, %{"slug" => slug}) do
    with {:ok, page} <- Content.get_page_by_slug(slug) |> nil_is_not_found() do
      render(conn, :show, page: page)
    end
  end
end
