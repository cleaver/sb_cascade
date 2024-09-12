defmodule SbCascade.Helpers.Param do
  @moduledoc """
  Query helpers.
  """

  def string_keys_to_atom_keys(map) do
    Map.new(map, fn {k, v} -> {maybe_convert_to_atom(k), v} end)
  end

  defp maybe_convert_to_atom(value) when is_atom(value), do: value
  defp maybe_convert_to_atom(value), do: String.to_existing_atom(value)

  def set_admin_default_page_size(map) do
    admin_default_page_size = Application.get_env(:sb_cascade, :admin_default_page_size)
    Map.put_new(map, :page_size, admin_default_page_size)
  end

  def set_api_default_page_size(map) do
    api_default_page_size = Application.get_env(:sb_cascade, :api_default_page_size)
    Map.put_new(map, :page_size, api_default_page_size)
  end

  def set_default_order(map, field_name, direction \\ :asc) do
    case Map.get(map, :order_by) do
      nil ->
        map
        |> Map.put(:order_by, [field_name])
        |> Map.put(:order_directions, [direction])

      _ ->
        map
    end
  end

  def convert_page_numbers_to_integer(map) do
    map
    |> Enum.map(&convert_page_value_to_integer/1)
    |> Map.new()
  end

  defp convert_page_value_to_integer({key, value})
       when key in [:page, :page_size] and is_binary(value) do
    {key, String.to_integer(value)}
  end

  defp convert_page_value_to_integer({key, value}), do: {key, value}
end
