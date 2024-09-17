defmodule SbCascadeWeb.SiteLive.Settings do
  use SbCascadeWeb, :live_view

  require Logger

  alias SbCascade.Site

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |> assign(settings_group: Site.get_settings_group())
      |> assign_form(%{})

    {:noreply, socket}
  end

  defp assign_form(socket, attrs) do
    form =
      socket.assigns.settings_group
      |> Site.change_settings_group(attrs)
      |> to_form()

    assign(socket, form: form)
  end

  @impl true
  def handle_event("validate", %{"settings_group" => params}, socket) do
    form =
      socket.assigns.settings_group
      |> Site.change_settings_group(params)
      |> to_form(action: :validate)

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"settings_group" => attrs}, socket) do
    case Site.update_settings_group(socket.assigns.settings_group, attrs) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Settings saved successfully.")
          |> push_patch(to: ~p"/site_settings")

        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error updating settings: #{inspect(changeset)}")

        socket =
          socket
          |> put_flash(:error, "Did not save setttings.")
          |> assign(form: to_form(changeset))

        {:noreply, socket}
    end
  end
end
