defmodule SbCascadeWeb.TagLive.Index do
  use SbCascadeWeb, :live_view

  alias SbCascade.Content
  alias SbCascade.Content.Tag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tags, Content.list_tags())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
  def handle_info({SbCascadeWeb.TagLive.FormComponent, {:saved, tag}}, socket) do
    {:noreply, stream_insert(socket, :tags, tag)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tag = Content.get_tag!(id)
    {:ok, _} = Content.delete_tag(tag)

    {:noreply, stream_delete(socket, :tags, tag)}
  end
end