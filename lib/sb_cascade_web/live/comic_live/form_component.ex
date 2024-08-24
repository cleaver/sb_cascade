defmodule SbCascadeWeb.ComicLive.FormComponent do
  use SbCascadeWeb, :live_component

  alias SbCascade.Content

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 rounded bg-light_bg dark:bg-light_bg_dark">
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="comic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="textarea" rows="7" label="Body" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <div class="flex gap-6">
          <div class="flex-1">
            <.input field={@form[:post_date]} type="date" label="Post date" />
          </div>
          <div class="flex-1">
            <.input field={@form[:published]} type="checkbox" label="Published" />
          </div>
        </div>
        <.input field={@form[:meta_description]} type="text" label="Meta description" />
        <.input field={@form[:image_alt_text]} type="text" label="Image alt text" />
        <:actions>
          <div class="w-full flex justify-end space-x-6">
            <.button type="button" phx-click={JS.patch(~p"/comics")} color="secondary">
              Cancel
            </.button>
            <.button phx-disable-with="Saving..." color="primary">
              Save Comic
            </.button>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{comic: comic} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Content.change_comic(comic))
     end)}
  end

  @impl true
  def handle_event("validate", %{"comic" => comic_params}, socket) do
    changeset = Content.change_comic(socket.assigns.comic, comic_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
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
