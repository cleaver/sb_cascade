defmodule SbCascadeWeb.TagLive.Index do
  use SbCascadeWeb, :live_view

  alias SbCascade.Content
  alias SbCascade.Content.Tag

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
    case Content.list_tags(socket.assigns.params) do
      {:ok, {tags, meta}} ->
        {:noreply, assign(socket, %{tags: tags, meta: meta})}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/tags")}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tag")
    |> assign(:tag, Content.get_tag!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tag")
    |> assign(:tag, %Tag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tags")
    |> assign(:tag, nil)
  end

  @impl true
  def handle_info({SbCascadeWeb.TagLive.FormComponent, {:saved, _tag}}, socket) do
    fetch_data(socket)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tag = Content.get_tag!(id)
    {:ok, _} = Content.delete_tag(tag)

    fetch_data(socket)
  end
end
