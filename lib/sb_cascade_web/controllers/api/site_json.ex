defmodule SbCascadeWeb.Api.SiteJSON do
  @moduledoc """
  Format JSON for site settings.
  """
  alias SbCascade.Site.Setting

  @doc """
  Renders a list of sites.
  """
  def index(%{settings: settings}) do
    %{data: for(setting <- settings, do: data(setting))}
  end

  @doc """
  Renders a single setting.
  """
  def show(%{setting: setting}) do
    %{data: data(setting)}
  end

  @doc """
  Formats a setting record for JSON.
  """
  def data(%Setting{} = setting) do
    %{
      id: setting.id,
      key: setting.key,
      value: setting.value,
      inserted_at: setting.inserted_at,
      updated_at: setting.updated_at
    }
  end

  def data(column) when is_binary(column), do: column
end
