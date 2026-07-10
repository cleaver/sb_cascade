defmodule SbCascadeWeb.PageLive.Index do
  use SbCascadeWeb, :live_view

  import SbCascadeWeb.Components.Flop.FilterForm

  alias SbCascade.Content
  alias SbCascade.Content.Page

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) when socket.assigns.live_action in [:edit, :new] do
    socket = assign(socket, :page_title, page_title(socket.assigns.live_action))
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_params(params, _url, socket) do
    socket
    |> assign(:page_title, page_title(:index))
    |> assign(params: params)
    |> fetch_data()
  end

  defp fetch_data(socket) do
    case Content.list_pages(socket.assigns.params) do
      {:ok, {pages, meta}} ->
        {:noreply, assign(socket, %{pages: pages, meta: meta})}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/pages")}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page, Content.get_page!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page, %Page{})
  end

  defp page_title(:index), do: "Listing Pages"
  defp page_title(:edit), do: "Edit Page"
  defp page_title(:new), do: "New Page"

  @impl true
  def handle_info({SbCascadeWeb.PageLive.FormComponent, {:saved, _page}}, socket) do
    fetch_data(socket)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    page = Content.get_page!(id)
    {:ok, _} = Content.delete_page(page)

    fetch_data(socket)
  end

  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/pages?#{params}")}
  end
end
