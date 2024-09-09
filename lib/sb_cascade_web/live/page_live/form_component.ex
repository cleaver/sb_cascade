defmodule SbCascadeWeb.PageLive.FormComponent do
  use SbCascadeWeb, :live_component

  require Logger

  alias SbCascade.Content
  alias SbCascadeWeb.Components.MediaBrowser

  @impl true
  def update(%{page: page} = assigns, socket) do
    changeset = Content.change_page(page)

    socket =
      socket
      |> assign(assigns)
      |> assign_form(changeset)
      |> assign_media(page)
      |> assign(show_media_browser: false)

    {:ok, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_media(socket, %{media_id: media_id}) when is_number(media_id) do
    media_image = Content.get_file!(media_id)
    assign(socket, media_image: media_image)
  end

  defp assign_media(socket, _params) do
    assign(socket, media_image: %Content.File{})
  end

  @impl true
  def handle_event("show-media-browser", _params, socket) do
    {:noreply, assign(socket, show_media_browser: true)}
  end

  def handle_event("hide-media-browser", _params, socket) do
    {:noreply, assign(socket, show_media_browser: false)}
  end

  def handle_event("select-media", %{"media_id" => media_id}, socket) do
    media_image = Content.get_file!(media_id)

    socket =
      socket
      |> assign(media_image: media_image)
      |> assign(show_media_browser: false)

    {:noreply, socket}
  end

  def handle_event("validate", %{"page" => page_params}, socket) do
    page_form =
      socket.assigns.page
      |> Content.change_page(page_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: page_form)}
  end

  def handle_event("save", %{"page" => page_params}, socket) do
    save_page(socket, socket.assigns.action, page_params)
  end

  defp save_page(socket, :edit, page_params) do
    page_params = set_media_id(socket, page_params)

    case Content.update_page(socket.assigns.page, page_params) do
      {:ok, page} ->
        notify_parent({:saved, page})

        {:noreply,
         socket
         |> put_flash(:info, "Page updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error updating page: #{inspect(changeset)}")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_page(socket, :new, page_params) do
    page_params = set_media_id(socket, page_params)

    case Content.create_page(page_params) do
      {:ok, page} ->
        notify_parent({:saved, page})

        {:noreply,
         socket
         |> put_flash(:info, "Page created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error creating page: #{inspect(changeset)}")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp set_media_id(socket, params) do
    Map.put(params, "media_id", socket.assigns.media_image.id)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
