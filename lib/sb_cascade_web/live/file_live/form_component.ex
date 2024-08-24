defmodule SbCascadeWeb.FileLive.FormComponent do
  use SbCascadeWeb, :live_component

  import SbCascade.Helpers.File

  alias SbCascade.Content
  alias SbCascadeWeb.UI.Image

  @impl true
  def update(%{file: file} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:show_browser, false)
     |> assign(existing_image: file.url)
     |> allow_upload(:image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 5_000_000
     )
     |> assign_new(:form, fn ->
       to_form(Content.change_file(file))
     end)}
  end

  @impl true
  def handle_event("validate", %{"file" => file_params}, socket) do
    file_params = set_url_placeholder(socket, file_params)
    changeset = Content.change_file(socket.assigns.file, file_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"file" => file_params}, socket) do
    save_file(socket, socket.assigns.action, file_params)
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  def handle_event("show-browser", _, socket) do
    {:noreply, assign(socket, show_browser: true)}
  end

  def handle_event("delete-image", _, socket) do
    {:noreply, assign(socket, existing_image: nil)}
  end

  defp set_url_placeholder(socket, file_params) do
    case socket.assigns.uploads.image.entries do
      [entry | _] -> Map.put(file_params, "url", "/uploads/#{entry.client_name}")
      _ -> file_params
    end
  end

  defp save_file(socket, :edit, file_params) do
    file_params = maybe_update_file_url(socket, file_params)

    case Content.update_file(socket.assigns.file, file_params) do
      {:ok, file} ->
        if socket.assigns.file.url != file.url do
          delete_uploaded_file(socket.assigns.file.url)
        end

        notify_parent({:saved, file})

        {:noreply,
         socket
         |> put_flash(:info, "File updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_file(socket, :new, file_params) do
    [file_url] = copy_uploaded_file(socket)

    file_params = Map.put(file_params, "url", file_url)

    case Content.create_file(file_params) do
      {:ok, file} ->
        notify_parent({:saved, file})

        {:noreply,
         socket
         |> put_flash(:info, "File created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp maybe_update_file_url(socket, file_params) do
    case socket.assigns.uploads.image.entries do
      [_entry | _] ->
        [file_url] = copy_uploaded_file(socket)
        Map.put(file_params, "url", file_url)

      _ ->
        file_params
    end
  end

  defp copy_uploaded_file(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
      destination_filename = copy_file_to_upload_path(path, entry.client_name)
      {:ok, ~p"/uploads/#{Path.basename(destination_filename)}"}
    end)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
