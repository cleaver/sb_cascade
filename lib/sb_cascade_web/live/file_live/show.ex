defmodule SbCascadeWeb.FileLive.Show do
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
     |> assign(:file, Content.get_file!(id))}
  end

  defp page_title(:show), do: "Show File"
  defp page_title(:edit), do: "Edit File"
end
