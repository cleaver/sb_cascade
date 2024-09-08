defmodule SbCascadeWeb.FileLive.Index do
  use SbCascadeWeb, :live_view

  import SbCascadeWeb.Components.Flop.FilterForm
  import SbCascade.Helpers.File, only: [delete_uploaded_file: 1]

  alias SbCascade.Content
  alias SbCascade.Content.File

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
    case Content.list_files(socket.assigns.params) do
      {:ok, {files, meta}} ->
        {:noreply, assign(socket, %{files: files, meta: meta})}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/files")}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit File")
    |> assign(:file, Content.get_file!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New File")
    |> assign(:file, %File{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Files")
    |> assign(:file, nil)
  end

  @impl true
  def handle_info({SbCascadeWeb.FileLive.FormComponent, {:saved, _file}}, socket) do
    fetch_data(socket)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    file = Content.get_file!(id)
    {:ok, _} = Content.delete_file(file)
    delete_uploaded_file(file.url)

    fetch_data(socket)
  end

  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/files?#{params}")}
  end
end
