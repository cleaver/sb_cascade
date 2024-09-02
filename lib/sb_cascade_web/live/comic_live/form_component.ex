defmodule SbCascadeWeb.ComicLive.FormComponent do
  alias SbCascade.Content.ComicTag
  use SbCascadeWeb, :live_component

  alias SbCascade.Content

  @impl true
  def update(%{comic: comic} = assigns, socket) do
    changeset = Content.change_comic(comic)

    socket =
      socket
      |> assign(assigns)
      |> assign_form(changeset)
      |> assign_tags()
      |> assign(show_media_browser: false)

    {:ok, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    if Ecto.Changeset.get_field(changeset, :comic_tags) == [] do
      comic_tag = %ComicTag{}
      changeset = Ecto.Changeset.put_change(changeset, :comic_tags, [comic_tag])
      assign(socket, :form, to_form(changeset))
    else
      assign(socket, :form, to_form(changeset))
    end
  end

  defp assign_tags(socket) do
    tags = Content.list_tag_options()
    assign(socket, tags: tags)
  end

  @impl true
  def handle_event("show-media-browser", _params, socket) do
    {:noreply, assign(socket, show_media_browser: true)}
  end

  def handle_event("hide-media-browser", _params, socket) do
    {:noreply, assign(socket, show_media_browser: false)}
  end

  def handle_event("validate", %{"comic" => comic_params}, socket) do
    comic_form =
      socket.assigns.comic
      |> Content.change_comic(comic_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, :form, comic_form)}
  end

  def handle_event("save", %{"comic" => comic_params}, socket) do
    save_comic(socket, socket.assigns.action, comic_params)
  end

  defp save_comic(socket, :edit, comic_params) do
    case Content.update_comic(socket.assigns.comic, comic_params) do
      {:ok, comic} ->
        notify_parent({:saved, comic})

        {:noreply,
         socket
         |> put_flash(:info, "Comic updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_comic(socket, :new, comic_params) do
    case Content.create_comic(comic_params) do
      {:ok, comic} ->
        notify_parent({:saved, comic})

        {:noreply,
         socket
         |> put_flash(:info, "Comic created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
