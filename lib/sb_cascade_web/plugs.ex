defmodule SbCascadeWeb.Plugs do
  @moduledoc """
  Custom plugs.
  """

  import Plug.Conn
  import Phoenix.Controller

  def assign_current_path(conn, _) do
    assign(conn, :current_path, current_path(conn))
  end

  def assign_allow_registration(conn, _) do
    allow_registration =
      Application.get_env(:sb_cascade, :allow_registration, false)

    assign(conn, :allow_registration, allow_registration)
  end
end
