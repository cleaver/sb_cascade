defmodule SbCascadeWeb.Components.CustomComponents do
  @moduledoc """
  Custom components for the SbCascade application.
  """
  alias SbCascadeWeb.CoreComponents
  use Phoenix.Component

  def placeholder_for_later_use do
    # This is a placeholder for later use.
  end

  attr :datetime, :string, required: true
  attr :rest, :global

  def time(assigns) do
    ~H"""
    <time datetime={@datetime}>{DateTime.to_string(@datetime)}</time>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def select(assigns) do
    errors = if Phoenix.Component.used_input?(assigns.field), do: assigns.errors, else: []

    assigns =
      assign(
        assigns,
        :errors,
        Enum.map(errors, &Gettext.dgettext(SbCascadeWeb.Gettext, "errors", &1))
      )

    ~H"""
    <div>
      <select
        id={@field.id}
        name={@field.name}
        class="mt-1 rounded-md border border-gray-300 bg-body dark:bg-body_bg_dark shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        {@rest}
      >
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @field.value)}
      </select>
      <CoreComponents.error :for={msg <- @errors}>{msg}</CoreComponents.error>
    </div>
    """
  end
end
