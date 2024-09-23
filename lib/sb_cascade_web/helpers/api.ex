defmodule SbCascadeWeb.Helpers.Api do
  @moduledoc """
  Helper functions for API controllers.
  """

  import Phoenix.ConnTest
  import Plug.Conn

  @endpoint SbCascadeWeb.Endpoint

  @doc """
  Return an error for fallback controller if the value is nil.
  """
  def nil_is_not_found(nil), do: {:error, :not_found}
  def nil_is_not_found(value), do: {:ok, value}

  @doc """
  Return a JSON response from a connection requiring authentication.
  """
  def authenticated_request(conn, token, url) do
    conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> put_req_header("accept", "application/json")
    |> put_req_header("content-type", "application/json")
    |> get(url)
  end
end
