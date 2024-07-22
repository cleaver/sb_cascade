defmodule SbCascadeWeb.Components.Sections.Navigation do
  @moduledoc """
  Navigation components.
  """

  use SbCascadeWeb, :html

  def side_menu(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col justify-between">
      <div>
        <ul class="relative z-10 flex flex-col items-center gap-4 px-4 sm:px-6 lg:px-8">
          <%= if @current_user do %>
            <li class="">
              <.link
                href={~p"/comics"}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Comics
              </.link>
            </li>
          <% end %>
        </ul>
      </div>
      <div>
        <ul class="relative z-10 flex flex-col items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
          <%= if @current_user do %>
            <li class="text-[0.8125rem] leading-6 text-zinc-900">
              <%= @current_user.email %>
            </li>
            <li>
              <.link
                href={~p"/users/settings"}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Settings
              </.link>
            </li>
            <li>
              <.link
                href={~p"/users/log_out"}
                method="delete"
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Log out
              </.link>
            </li>
          <% else %>
            <li>
              <.link
                href={~p"/users/register"}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Register
              </.link>
            </li>
            <li>
              <.link
                href={~p"/users/log_in"}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Log in
              </.link>
            </li>
          <% end %>
          <li class="mb-6 text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700">
            <SbCascadeWeb.Components.ToggleTheme.render />
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
