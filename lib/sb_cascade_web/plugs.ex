defmodule SbCascadeWeb.Plugs do
  @moduledoc """
  Custom plugs.
  """

  import Plug.Conn
  import Phoenix.Controller

  def assign_current_path(conn, _) do
    assign(conn, :current_path, current_path(conn))
  end
end
