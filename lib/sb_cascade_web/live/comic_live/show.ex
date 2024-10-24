defmodule SbCascadeWeb.ComicLive.Show do
  use SbCascadeWeb, :live_view

  alias SbCascade.Content

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comic, Content.get_comic!(id, preload: [:tags, :media]))}
  end

  defp page_title(:show), do: "Show Comic"
  defp page_title(:edit), do: "Edit Comic"
end
