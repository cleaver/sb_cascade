defmodule SbCascadeWeb.Api.TagController do
  @moduledoc """
  API controller for tags.
  """

  use SbCascadeWeb, :controller

  import SbCascadeWeb.Helpers.Api

  alias SbCascade.Content
  alias SbCascadeWeb.Api.FallbackController

  action_fallback FallbackController

  def index(conn, %{"select" => select_column} = _params) do
    tags = Content.list_tags_column(select_column)
    render(conn, :index, tags: tags)
  end

  def index(conn, _params) do
    tags = Content.list_tags_preloaded()
    render(conn, :index, tags: tags)
  end

  def show(conn, %{"slug" => slug}) do
    with {:ok, tag} <- Content.get_tag_by_slug(slug) |> nil_is_not_found() do
      render(conn, :show, tag: tag)
    end
  end
end
