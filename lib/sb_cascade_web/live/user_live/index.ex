defmodule SbCascadeWeb.UserLive.Index do
  use SbCascadeWeb, :live_view

  alias SbCascade.Accounts
  alias SbCascade.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    user = Accounts.get_user!(id)

    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, user)
    |> assign(:form, to_form(Accounts.change_admin_user(user)))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
    |> assign(:form, to_form(Accounts.change_admin_user(%User{})))
  end

  defp apply_action(socket, :index, _params) do
    users = Accounts.list_users()

    socket
    |> assign(:page_title, "Users")
    |> assign(:user, nil)
    |> assign(:form, nil)
    |> stream(:users, users, reset: true)
  end

  @impl true
  def handle_info({SbCascadeWeb.UserLive.FormComponent, {:saved, user}}, socket) do
    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    if user.id == socket.assigns.current_user.id do
      {:noreply,
       socket
       |> put_flash(:error, "You cannot delete your own account.")
       |> push_patch(to: ~p"/admin/users")}
    else
      {:ok, _} = Accounts.delete_user(user)

      {:noreply,
       socket
       |> put_flash(:info, "User deleted successfully.")
       |> stream_delete(:users, user)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-6xl">
      <.header>
        Users
        <:subtitle>Manage administrator accounts</:subtitle>
        <:actions>
          <.link patch={~p"/admin/users/new"}>
            <.button>New User</.button>
          </.link>
        </:actions>
      </.header>

      <div
        :if={@live_action == :index}
        class="bg-content_bg dark:bg-content_bg_dark rounded-lg shadow-sm p-6 mt-6"
      >
        <table class="w-full">
          <thead>
            <tr class="text-left text-sm font-semibold text-body_text/60 dark:text-body_text_dark/60 border-b border-outline dark:border-outline_dark">
              <th class="pb-3 pr-4">Email</th>
              <th class="pb-3 pr-4">Super User</th>
              <th class="pb-3 pr-4">Confirmed</th>
              <th class="pb-3 pr-4">Created</th>
              <th class="pb-3"></th>
            </tr>
          </thead>
          <tbody
            id="users"
            phx-update="stream"
            class="relative divide-y divide-outline dark:divide-outline_dark
              border-t border-outline dark:border-outline_dark text-sm leading-6 text-body_text dark:text-body_text_dark"
          >
            <tr
              :for={{id, user} <- @streams.users}
              id={id}
              class="group border-b border-outline/30 dark:border-outline_dark/30 hover:bg-body_bg/50 dark:hover:bg-body_bg_dark/50"
            >
              <td class="py-3 pr-4">
                <.link
                  patch={~p"/admin/users/#{user.id}/edit"}
                  class="font-medium hover:text-link"
                >
                  {user.email}
                </.link>
              </td>
              <td class="py-3 pr-4">
                <.icon
                  name={
                    if user.super_user, do: "hero-check-circle-solid", else: "hero-x-circle-solid"
                  }
                  class={
                    if user.super_user, do: "text-green-500 h-5 w-5", else: "text-gray-400 h-5 w-5"
                  }
                />
              </td>
              <td class="py-3 pr-4">
                <.icon
                  name={
                    if user.confirmed_at, do: "hero-check-circle-solid", else: "hero-x-circle-solid"
                  }
                  class={
                    if user.confirmed_at, do: "text-green-500 h-5 w-5", else: "text-gray-400 h-5 w-5"
                  }
                />
              </td>
              <td class="py-3 pr-4 text-sm">
                {user.inserted_at && Calendar.strftime(user.inserted_at, "%b %d, %Y")}
              </td>
              <td class="py-3 text-right whitespace-nowrap">
                <.link patch={~p"/admin/users/#{user.id}/edit"} class="mr-2">
                  <.button class="text-sm">Edit</.button>
                </.link>
                <.link
                  phx-click={JS.push("delete", value: %{id: user.id}) |> hide("##{id}")}
                  data-confirm={"Are you sure you want to delete #{user.email}?"}
                >
                  <.button class="!bg-red-600 hover:!bg-red-700 text-sm">Delete</.button>
                </.link>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <.live_component
      :if={@live_action in [:new, :edit]}
      module={SbCascadeWeb.UserLive.FormComponent}
      id={@user.id || :new}
      title={@page_title}
      action={@live_action}
      user={@user}
      current_user={@current_user}
      patch={~p"/admin/users"}
    />
    """
  end
end
