defmodule SbCascadeWeb.FileLive.FormComponent do
  use SbCascadeWeb, :live_component

  import SbCascadeWeb.Helpers.Upload

  alias SbCascade.Content

  @impl true
  def update(%{file: file} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:show_browser, false)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)
     |> assign_new(:form, fn ->
       to_form(Content.change_file(file))
     end)}
  end

  @impl true
  def handle_event("validate", %{"file" => file_params}, socket) do
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

  defp save_file(socket, :edit, file_params) do
    case Content.update_file(socket.assigns.file, file_params) do
      {:ok, file} ->
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

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
