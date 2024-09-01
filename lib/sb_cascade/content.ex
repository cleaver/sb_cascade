defmodule SbCascade.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  import SbCascade.Helpers.Param
  alias SbCascade.Repo

  alias SbCascade.Content.Comic
  alias SbCascade.Content.File
  alias SbCascade.Helpers.File, as: FileHelper
  alias SbCascade.Content.Tag

  @doc """
  Returns the list of comics.

  ## Examples

      iex> list_comics()
      [%Comic{}, ...]

  """
  def list_comics do
    Comic
    |> order_by([p], desc: p.post_date)
    |> Repo.all()
  end

  def list_comics(params) do
    params =
      params
      |> string_keys_to_atom_keys()
      |> set_default_page_size()
      |> set_default_order(:post_date, :desc)

    Flop.validate_and_run(Comic, params, for: Comic)
  end

  @doc """
  Gets a single comic.

  Raises `Ecto.NoResultsError` if the Comic does not exist.

  ## Examples

      iex> get_comic!(123)
      %Comic{}

      iex> get_comic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comic!(id) do
    Comic
    |> Repo.get!(id)
    |> Repo.preload([:comic_tags])
  end

  def get_comic!(id, load: :tags) do
    Comic
    |> Repo.get!(id)
    |> Repo.preload([:tags])
  end

  @doc """
  Creates a comic.

  ## Examples

      iex> create_comic(%{field: value})
      {:ok, %Comic{}}

      iex> create_comic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comic(attrs \\ %{}) do
    %Comic{}
    |> Comic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comic.

  ## Examples

      iex> update_comic(comic, %{field: new_value})
      {:ok, %Comic{}}

      iex> update_comic(comic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comic(%Comic{} = comic, attrs) do
    comic
    |> Comic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comic.

  ## Examples

      iex> delete_comic(comic)
      {:ok, %Comic{}}

      iex> delete_comic(comic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comic(%Comic{} = comic) do
    Repo.delete(comic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comic changes.

  ## Examples

      iex> change_comic(comic)
      %Ecto.Changeset{data: %Comic{}}

  """
  def change_comic(%Comic{} = comic, attrs \\ %{}) do
    Comic.changeset(comic, attrs)
  end

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_files do
    Repo.all(File)
  end

  def list_files(params) do
    params =
      params
      |> string_keys_to_atom_keys()
      |> set_default_page_size()
      |> set_default_order(:inserted_at, :desc)

    Flop.validate_and_run(File, params, for: File)
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file!(id), do: Repo.get!(File, id)

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file record and the filesystem.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    new_file_url = attrs["url"]

    file
    |> File.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, file} ->
        if file.url != new_file_url do
          FileHelper.delete_uploaded_file(new_file_url)
        end

        {:ok, file}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a file.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{data: %File{}}

  """
  def change_file(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  def list_tags(params) do
    params =
      params
      |> string_keys_to_atom_keys()
      |> set_default_page_size()
      |> set_default_order(:inserted_at, :desc)

    Flop.validate_and_run(Tag, params, for: Tag)
  end

  @doc """
  Returns a list of tag options for select inputs.
  """
  def list_tag_options do
    Repo.all(Tag)
    |> Enum.map(&{&1.name, &1.id})
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
