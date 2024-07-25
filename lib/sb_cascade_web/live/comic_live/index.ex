defmodule SbCascadeWeb.ComicLive.Index do
  use SbCascadeWeb, :live_view

  alias SbCascade.Content
  alias SbCascade.Content.Comic

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :comics, Content.list_comics())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Comic")
    |> assign(:comic, Content.get_comic!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Comic")
    |> assign(:comic, %Comic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Comics")
    |> assign(:comic, nil)
  end

  @impl true
  def handle_info({SbCascadeWeb.ComicLive.FormComponent, {:saved, _comic}}, socket) do
    {:noreply, stream(socket, :comics, Content.list_comics())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comic = Content.get_comic!(id)
    {:ok, _} = Content.delete_comic(comic)

    {:noreply, stream_delete(socket, :comics, comic)}
  end
end
