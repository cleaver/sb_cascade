defmodule SbCascadeWeb.Components.CustomComponents do
  @moduledoc """
  Custom components for the SbCascade application.
  """
  use Phoenix.Component

  def placeholder_for_later_use do
    # This is a placeholder for later use.
  end

  def table_opts do
    [
      container: true,
      container_attrs: [
        class:
          "mt-6 overflow-y-auto pb-3 rounded-md sm:overflow-visible sm:px-0 bg-light_bg dark:bg-light_bg_dark"
      ],
      table_attrs: [
        class: "table-auto w-full"
      ],
      thead_attrs: [
        class: "text-sm text-left leading-6 text-light_text dark:text-light_text_dark"
      ],
      thead_th_attrs: [
        class: "py-4 pl-4"
      ],
      tbody_attrs: [
        class: "relative divide-y divide-outline dark:divide-outline_dark
              border-t border-outline dark:border-outline_dark text-sm leading-6 text-body_text dark:text-body_text_dark
              bg-light_bg dark:bg-light_bg_dark"
      ],
      tbody_tr_attrs: [
        class: "group hover:bg-body_bg hover:dark:bg-body_bg_dark"
      ],
      tbody_td_attrs: [
        class: "py-4 pl-4"
      ]
    ]
  end

  def pagination_opts do
    [
      page_links: {:ellipsis, 5},
      wrapper_attrs: [
        class: "mt-4 flex justify-end space-x-2"
      ],
      previous_link_attrs: [
        class:
          "bg-secondary dark:bg-secondary_dark hover:bg-brand dark:hover:bg-brand_dark text-white dark:text-white px-3 py-1 rounded-md"
      ],
      next_link_attrs: [
        class:
          "order-last bg-secondary dark:bg-secondary_dark hover:bg-brand dark:hover:bg-brand_dark text-white dark:text-white px-3 py-1 rounded-md"
      ],
      pagination_list_attrs: [
        class: "flex space-x-1 mt-1"
      ],
      pagination_link_attrs: [
        class: "text-light_text dark:text-light_text_dark px-3 py-1"
      ],
      current_link_attrs: [
        class: "text-body_text dark:text-body_text_dark font-bold px-3 py-1"
      ],
    ]
  end
end
