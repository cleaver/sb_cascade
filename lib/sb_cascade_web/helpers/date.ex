defmodule SbCascadeWeb.Helpers.Date do
  @moduledoc """
  Date helpers.
  """

  def format_medium_datetime(datetime) do
    Calendar.strftime(datetime, "%Y-%m-%d %H:%M:%S")
  end
end
