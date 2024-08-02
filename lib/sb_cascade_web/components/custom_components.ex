defmodule SbCascadeWeb.Components.CustomComponents do
  @moduledoc """
  Custom components for the SbCascade application.
  """
  use Phoenix.Component

  def placeholder_for_later_use do
    # This is a placeholder for later use.
  end

  attr :datetime, :string, required: true
  attr :rest, :global

  def time(assigns) do
    ~H"""
    <time datetime={@datetime}><%= DateTime.to_string(@datetime) %></time>
    """
  end
end
