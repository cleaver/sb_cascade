defmodule SbCascadeWeb.Api.SiteController do
  @moduledoc """
  API controller for site settings.
  """

  use SbCascadeWeb, :controller

  import SbCascadeWeb.Helpers.Api

  alias SbCascade.Site
  alias SbCascadeWeb.Api.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    settings = Site.list_settings()
    render(conn, :index, settings: settings)
  end

  def show(conn, %{"setting" => setting}) do
    with {:ok, setting} <- Site.get_setting(setting) |> nil_is_not_found() do
      render(conn, :show, setting: setting)
    end
  end
end
