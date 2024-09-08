defmodule SbCascadeWeb.PageController do
  use SbCascadeWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: "/comics")
  end
end
