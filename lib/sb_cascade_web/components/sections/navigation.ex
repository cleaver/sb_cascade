defmodule SbCascadeWeb.Components.Sections.Navigation do
  @moduledoc """
  Navigation components.
  """

  use SbCascadeWeb, :html

  def side_menu(assigns) do
    ~H"""
    <nav class="text-nav_text dark:text-nav_text_dark bg-nav_bg dark:bg-nav_bg_dark min-h-screen
        flex flex-col justify-between border-r border-nav_border dark:border-nav_border_dark">
      <div class="pb-4">
        <div class="z-10 p-4 mb-6 border-b border-nav_border dark:border-nav_border_dark font-bold text-lg">
          SorrowbaconCMS
        </div>
        <div>
          <ul class="relative z-10 flex flex-col gap-6 px-4 sm:px-6 lg:px-8">
            <%= if @current_user do %>
              <li class="">
                <.link
                  href={~p"/comics"}
                  class="leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
                >
                  <span class="pr-2"><.icon name="hero-paint-brush-solid" class="h-5 w-5" /></span>
                  Comics
                </.link>
              </li>
              <li class="">
                <.link
                  href={~p"/files"}
                  class="leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
                >
                  <span class="pr-2"><.icon name="hero-photo-solid" class="h-5 w-5" /></span> Media
                </.link>
              </li>
              <li class="">
                <.link
                  href={~p"/tags"}
                  class="leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
                >
                  <span class="pr-2"><.icon name="hero-tag-solid" class="h-5 w-5" /></span> Tags
                </.link>
              </li>
              <li class="">
                <.link
                  href={~p"/pages"}
                  class="leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
                >
                  <span class="pr-2"><.icon name="hero-newspaper-solid" class="h-5 w-5" /></span>
                  Pages
                </.link>
              </li>
              <li class="">
                <.link
                  href={~p"/site_settings"}
                  class="leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
                >
                  <span class="pr-2"><.icon name="hero-globe-alt-solid" class="h-5 w-5" /></span> Site
                </.link>
              </li>
            <% end %>
          </ul>
        </div>
      </div>
      <div>
        <ul class="relative z-10 flex flex-col gap-3 px-4 sm:px-6 lg:px-8 justify-end">
          <%= if @current_user do %>
            <li class="text-[0.8125rem] leading-6 text-nav_text dark:text-nav_text_dark">
              <%= @current_user.email %>
            </li>
            <li>
              <.link
                href={~p"/users/settings"}
                class="text-[0.8125rem] leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
              >
                Settings
              </.link>
            </li>
            <li>
              <.link
                href={~p"/users/log_out"}
                method="delete"
                class="text-[0.8125rem] leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
              >
                Log out
              </.link>
            </li>
          <% else %>
            <%= if @allow_registration do %>
              <li>
                <.link
                  href={~p"/users/register"}
                  class="text-[0.8125rem] leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
                >
                  Register
                </.link>
              </li>
            <% end %>
            <li>
              <.link
                href={~p"/users/log_in"}
                class="text-[0.8125rem] leading-6 font-semibold hover:text-nav_text_hover dark:hover:text-nav_text_hover_dark"
              >
                Log in
              </.link>
            </li>
          <% end %>
          <li class="mb-6">
            <SbCascadeWeb.Components.ToggleTheme.render />
          </li>
        </ul>
      </div>
    </nav>
    """
  end
end
