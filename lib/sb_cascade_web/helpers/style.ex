defmodule SbCascadeWeb.Helpers.Style do
  @moduledoc """
  Helper functions for styling components.
  """

  def maybe_hide(true), do: "display: none;"
  def maybe_hide(_), do: ""

  def maybe_show(true), do: ""
  def maybe_show(_), do: "display: none;"
end
