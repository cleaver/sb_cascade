defmodule SbCascadeWeb.Components.MediaBrowser do
  @moduledoc """
  A component for browsing media.
  """
  use SbCascadeWeb, :live_component

  import SbCascadeWeb.Components.Flop.FilterForm

  alias SbCascade.Content

  @impl true
  def mount(socket) do
    socket = assign(socket, params: %{page_size: 6, page: 1})
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_data()

    {:ok, socket}
  end

  defp assign_data(socket) do
    {:ok, {files, meta}} = Content.list_files(socket.assigns.params)
    assign(socket, %{files: files, meta: meta})
  end

  @impl true

  def handle_event("paginate", %{"page" => page}, socket) do
    socket =
      socket
      |> assign(params: %{page: page})
      |> assign_data()

    {:noreply, socket}
  end

  def handle_event("update-filter", params, socket) do
    params =
      socket.assigns.params
      |> Map.merge(params)
      |> Map.delete("_target")

    socket =
      socket
      |> assign(params: params)
      |> assign_data()

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="media-browser">
      <div class="media-browser-header">
        <h2 class="text-2xl">Media Browser</h2>
      </div>
      <div class="my-6">
        <.filter_form
          fields={[name: [label: "Filter by name", op: :ilike, autofocus: true]]}
          meta={@meta}
          target={@myself}
          id="media_filter_form"
        />
      </div>
      <div class="my-6">
        <Flop.Phoenix.pagination meta={@meta} on_paginate={JS.push("paginate", target: @myself)} />
      </div>
      <div class="max-h-screen-3/5 overflow-y-scroll">
        <ul class="grid grid-cols-2 xl:grid-cols-3 gap-4">
          <li :for={file <- @files}>
            <div
              phx-click={JS.push("select-media", value: %{media_id: file.id}, target: @reply_to)}
              class="flex flex-col items-center cursor-pointer"
            >
              <img src={file.url} alt={file.name} class="rounded-lg" />
              <p class="my-2">{file.name}</p>
            </div>
          </li>
        </ul>
      </div>
      <Flop.Phoenix.pagination meta={@meta} on_paginate={JS.push("paginate", target: @myself)} />
    </div>
    """
  end
end
