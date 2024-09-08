defmodule SbCascadeWeb.ComicLive.Index do
  use SbCascadeWeb, :live_view

  import SbCascadeWeb.Components.Flop.FilterForm

  alias SbCascade.Content
  alias SbCascade.Content.Comic

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) when socket.assigns.live_action in [:edit, :new] do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_params(params, _url, socket) do
    socket
    |> assign(params: params)
    |> fetch_data()
  end

  defp fetch_data(socket) do
    case Content.list_comics(socket.assigns.params) do
      {:ok, {comics, meta}} ->
        {:noreply, assign(socket, %{comics: comics, meta: meta})}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/comics")}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Comic")
    |> assign(:comic, Content.get_comic!(id, preload: [:comic_tags]))
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
    fetch_data(socket)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comic = Content.get_comic!(id)
    {:ok, _} = Content.delete_comic(comic)

    fetch_data(socket)
  end

  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/comics?#{params}")}
  end
end
