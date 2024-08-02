defmodule SbCascade.Helpers.Param do
  @moduledoc """
  Query helpers.
  """

  def string_keys_to_atom_keys(map) do
    Map.new(map, fn {k, v} -> {String.to_existing_atom(k), v} end)
  end

  def set_default_page_size(map), do: Map.put(map, :page_size, 2)

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
end
