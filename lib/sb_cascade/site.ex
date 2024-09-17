defmodule SbCascade.Site do
  @moduledoc """
  The Site context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias SbCascade.Repo

  alias SbCascade.Site.Setting
  alias SbCascade.Site.SettingsGroup

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id) when is_binary(id), do: get_by_key!(id)
  def get_setting!(id), do: Repo.get!(Setting, id)

  defp get_by_key!(key) do
    Repo.get_by!(Setting, key: key)
  end

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting.

  ## Examples

      iex> delete_setting(setting)
      {:ok, %Setting{}}

      iex> delete_setting(setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

      iex> change_setting(setting)
      %Ecto.Changeset{data: %Setting{}}

  """
  def change_setting(%Setting{} = setting, attrs \\ %{}) do
    Setting.changeset(setting, attrs)
  end

  @doc """
  Get the setting group filled with settings.
  """
  def get_settings_group do
    settings = list_settings()
    settings_group_fields = get_settings_group_fields()

    Enum.reduce(settings, %SettingsGroup{}, fn setting, acc ->
      atom_key = String.to_existing_atom(setting.key)

      if atom_key in settings_group_fields do
        Map.put(acc, atom_key, setting.value)
      else
        acc
      end
    end)
  end

  defp get_settings_group_fields, do: Map.keys(%SettingsGroup{}) -- [:__struct__]

  @doc """
  Updates a setting group.
  """
  def update_settings_group(%SettingsGroup{} = settings_group, attrs) do
    group_changeset = change_settings_group(settings_group, attrs)

    Multi.new()
    |> Multi.run(:all_settings, fn repo, _ -> get_settings_group_settings(repo) end)
    |> Multi.run(:changes, fn _repo, %{all_settings: all_settings} ->
      compose_changesets(all_settings, group_changeset.changes)
    end)
    |> Multi.run(:update_settings, fn repo, %{changes: changes} ->
      apply_changes(repo, changes)
    end)
    |> Repo.transaction()
  end

  defp get_settings_group_settings(repo) do
    all_setting_keys =
      get_settings_group_fields()
      |> Enum.map(&Atom.to_string/1)

    settings_map =
      Setting
      |> where([s], s.key in ^all_setting_keys)
      |> repo.all()
      |> Enum.map(fn setting -> {String.to_atom(setting.key), setting} end)
      |> Enum.into(%{})

    {:ok, settings_map}
  end

  defp compose_changesets(all_settings, changes) do
    changesets =
      Enum.map(changes, fn {key, value} ->
        setting = Map.get(all_settings, key, %Setting{})
        change_setting(setting, %{key: Atom.to_string(key), value: value})
      end)

    {:ok, changesets}
  end

  defp apply_changes(repo, changesets) do
    Enum.reduce(changesets, {:ok, []}, fn changeset, {:ok, acc} ->
      case repo.insert_or_update(changeset) do
        {:ok, setting} -> {:ok, acc ++ [setting]}
        {:error, changeset} -> {:error, changeset}
      end
    end)
  end

  @doc """
  Creates a setting group changeset.
  """
  def change_settings_group(%SettingsGroup{} = settings_group, attrs \\ %{}) do
    SettingsGroup.changeset(settings_group, attrs)
  end
end
