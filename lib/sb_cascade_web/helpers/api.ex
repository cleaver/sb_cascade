defmodule SbCascadeWeb.Helpers.Api do
  @moduledoc """
  Helper functions for API controllers.
  """

  @doc """
  Return an error for fallback controller if the value is nil.
  """
  def nil_is_not_found(nil), do: {:error, :not_found}
  def nil_is_not_found(value), do: {:ok, value}
end
