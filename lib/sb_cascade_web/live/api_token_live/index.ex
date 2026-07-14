defmodule SbCascadeWeb.ApiTokenLive.Index do
  use SbCascadeWeb, :live_view

  alias SbCascade.Accounts

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users()

    user_options = [{"-- Select a user --", ""}] ++ Enum.map(users, &{&1.email, &1.id})

    socket =
      socket
      |> assign(:users, users)
      |> assign(:user_options, user_options)
      |> assign(:new_api_key, nil)
      |> assign(:form, to_form(%{"user_id" => ""}, as: :api_key))
      |> stream(:api_tokens, Accounts.list_api_tokens(), reset: true)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, :page_title, "API Keys")}
  end

  @impl true
  def handle_event("generate", %{"api_key" => %{"user_id" => user_id}}, socket)
      when user_id != nil and user_id != "" do
    user = Accounts.get_user!(user_id)
    token = Accounts.create_user_api_token(user)

    {:noreply,
     socket
     |> assign(:new_api_key, token)
     |> assign(:form, to_form(%{"user_id" => ""}, as: :api_key))
     |> stream(:api_tokens, Accounts.list_api_tokens(), reset: true)}
  end

  def handle_event("generate", _params, socket) do
    {:noreply, put_flash(socket, :error, "Please select a user.")}
  end

  @impl true
  def handle_event("dismiss_key", _params, socket) do
    {:noreply, assign(socket, :new_api_key, nil)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} = Accounts.delete_api_token(id)

    {:noreply,
     socket
     |> put_flash(:info, "API key deleted.")
     |> stream(:api_tokens, Accounts.list_api_tokens(), reset: true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-6xl">
      <.header>
        API Keys
        <:subtitle>Manage API tokens for programmatic access</:subtitle>
      </.header>

      <div
        :if={@new_api_key}
        id="new-api-key-banner"
        class="relative mt-6 rounded-lg p-4 bg-emerald-50 text-emerald-800 ring-1 ring-emerald-500"
      >
        <button
          id="dismiss-key-btn"
          phx-click={JS.push("dismiss_key")}
          class="absolute top-2 right-2 p-1 rounded hover:bg-emerald-200/50 transition-colors"
          aria-label="Close"
        >
          <.icon name="hero-x-mark-solid" class="h-5 w-5" />
        </button>
        <div class="flex items-center justify-between gap-4 pr-8">
          <div class="flex-1 min-w-0">
            <p class="font-semibold mb-1">
              New API Key Created — Copy it now. It won't be shown again.
            </p>
            <code
              id="new-api-key-value"
              class="block font-mono text-sm bg-black/10 rounded px-3 py-2 break-all select-all"
            >
              {@new_api_key}
            </code>
          </div>
          <button
            id="copy-api-key-btn"
            phx-hook=".CopyToClipboard"
            data-target="new-api-key-value"
            class="shrink-0 rounded-lg px-4 py-2 text-sm font-semibold bg-white border border-gray-300 hover:bg-gray-100 transition-colors"
          >
            Copy
          </button>
        </div>
      </div>

      <div class="bg-content_bg dark:bg-content_bg_dark rounded-lg shadow-sm p-6 mt-6">
        <div class="mb-6 pb-6 border-b border-outline dark:border-outline_dark">
          <.form for={@form} id="generate-form" phx-submit="generate">
            <div class="flex items-end gap-4">
              <div class="flex-1">
                <.input
                  field={@form[:user_id]}
                  type="select"
                  label="Generate API Key for"
                  options={@user_options}
                  id="api-key-user-select"
                />
              </div>
              <.button class="shrink-0">Generate API Key</.button>
            </div>
          </.form>
        </div>

        <table class="w-full">
          <thead>
            <tr class="text-left text-sm font-semibold text-body_text/60 dark:text-body_text_dark/60 border-b border-outline dark:border-outline_dark">
              <th class="pb-3 pr-4">User</th>
              <th class="pb-3 pr-4">Created</th>
              <th class="pb-3"></th>
            </tr>
          </thead>
          <tbody
            id="api_tokens"
            phx-update="stream"
            class="relative divide-y divide-outline dark:divide-outline_dark border-t border-outline dark:border-outline_dark text-sm leading-6 text-body_text dark:text-body_text_dark"
          >
            <tr
              :for={{id, token} <- @streams.api_tokens}
              id={id}
              class="group border-b border-outline/30 dark:border-outline_dark/30 hover:bg-body_bg/50 dark:hover:bg-body_bg_dark/50"
            >
              <td class="py-3 pr-4 font-medium">
                {token.user && token.user.email}
              </td>
              <td class="py-3 pr-4 text-sm">
                {token.inserted_at && Calendar.strftime(token.inserted_at, "%b %d, %Y at %H:%M")}
              </td>
              <td class="py-3 text-right whitespace-nowrap">
                <.link
                  phx-click={JS.push("delete", value: %{id: token.id}) |> hide("##{id}")}
                  data-confirm="Are you sure you want to delete this API key?"
                >
                  <.button class="!bg-red-600 hover:!bg-red-700 text-sm">Delete</.button>
                </.link>
              </td>
            </tr>
          </tbody>
        </table>

        <div class="hidden only:block text-center py-8 text-body_text/60 dark:text-body_text_dark/60">
          No API keys have been created yet.
        </div>
      </div>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".CopyToClipboard" runtime>
      {
        mounted() {
          this.el.addEventListener("click", (e) => {
            e.stopPropagation();
            const targetId = this.el.getAttribute("data-target");
            const target = document.getElementById(targetId);
            if (target) {
              navigator.clipboard.writeText(target.textContent.trim());
              this.el.textContent = "Copied!";
              setTimeout(() => { this.el.textContent = "Copy"; }, 2000);
            }
          });
        }
      }
    </script>
    """
  end
end
