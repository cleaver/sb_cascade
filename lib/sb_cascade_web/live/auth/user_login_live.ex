defmodule SbCascadeWeb.UserLoginLive do
  use SbCascadeWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          <%= if @allow_registration do %>
            Don't have an account?
            <.link
              navigate={~p"/users/register"}
              class="font-semibold text-brand dark:text-brand_dark hover:underline"
            >
              Sign up
            </.link>
            for an account now.
          <% end %>
        </:subtitle>
      </.header>
      <div class="rounded-lg mt-6 px-6 pt-1 pb-12 bg-light_bg dark:bg-light_bg_dark">
        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    allow_registration = Application.get_env(:sb_cascade, :allow_registration)

    socket =
      socket
      |> assign(allow_registration: allow_registration)
      |> assign(form: form)

    {:ok, socket, temporary_assigns: [form: form]}
  end
end
