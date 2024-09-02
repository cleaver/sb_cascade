defmodule SbCascadeWeb.Components.MediaBrowser do
  @moduledoc """
  A component for browsing media.
  """
  use SbCascadeWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="media-browser">
      <div class="media-browser-header">
        <h2>Media Browser</h2>
        <button phx-click="close" class="close-button">Close</button>
      </div>
      <div class="media-browser-content">
        <ul>
          <li>Media 1</li>
          <li>Media 2</li>
          <li>Media 3</li>
        </ul>
      </div>
    </div>
    """
  end
end
