defmodule SbCascadeWeb.UI.Image do
  @moduledoc """
  Image components.
  """
  use SbCascadeWeb, :html

  import SbCascadeWeb.Helpers.Upload

  attr :close_event, :string, required: true
  attr :target, :any, required: true
  attr :uploads, :map
  attr :entry, :map, default: %{}
  attr :src, :string, default: nil
  attr :rest, :global

  def thumbnail(assigns) do
    assigns = assign(assigns, image_ref: assigns.src || assigns.entry.ref)

    ~H"""
    <article class="flex flex-col items-end">
      <button
        type="button"
        phx-click={@close_event}
        phx-target={@target}
        phx-value-ref={@image_ref}
        aria-label="cancel"
        class="drop-shadow-lg"
      >
        <.icon
          name="hero-x-circle-solid"
          class="w-5 h-5 text-light_bg_text dark:text-light_text_dark"
        />
      </button>
      <figure class="drop-shadow-lg">
        <.live_img_preview :if={@entry != %{}} entry={@entry} class="max-w-56 h-auto" />
        <img :if={@src} src={@src} class="max-w-56 h-auto" />
      </figure>
      <progress :if={@entry != %{}} value={@entry.progress} max="100" class="w-full drop-shadow-lg">
        {@entry.progress}%
      </progress>
      <%= if @entry != %{} do %>
        <%= for err <- upload_errors(@uploads, @entry) do %>
          <p class="alert alert-danger">{error_to_string(err)}</p>
        <% end %>
      <% end %>
    </article>
    """
  end
end
