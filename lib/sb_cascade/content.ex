defmodule SbCascade.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias SbCascade.Repo

  alias SbCascade.Content.Comic

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
      |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)
      |> Map.put(:page_size, 2)
      |> maybe_set_order()

    Flop.validate_and_run(Comic, params, for: Comic)
  end

  defp maybe_set_order(params) do
    case Map.get(params, :order_by) do
      nil ->
        params
        |> Map.put(:order_by, [:post_date])
        |> Map.put(:order_directions, [:desc])

      _ ->
        params
    end
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
  def get_comic!(id), do: Repo.get!(Comic, id)

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
end
