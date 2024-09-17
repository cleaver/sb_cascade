defmodule SbCascade.SiteFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SbCascade.Site` context.
  """

  @default_settings_group_attrs %{
    "site_title" => "some title",
    "meta_title" => "some meta title",
    "meta_description" => "some meta description"
  }

  @doc """
  Generate a unique setting key.
  """
  def unique_setting_key, do: "some key#{System.unique_integer([:positive])}"

  @doc """
  Generate a setting.
  """
  def setting_fixture(attrs \\ %{}) do
    {:ok, setting} =
      attrs
      |> Enum.into(%{
        key: unique_setting_key(),
        value: "some value"
      })
      |> SbCascade.Site.create_setting()

    setting
  end

  def settings_group_fixture(attrs \\ %{}) do
    attrs = Map.merge(@default_settings_group_attrs, attrs)

    Enum.each(attrs, fn {key, value} ->
      setting_fixture(%{key: key, value: value})
    end)

    attrs
  end
end
