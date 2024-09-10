defmodule SbCascadeWeb.Api.FileJSON do
  @moduledoc """
  Format JSON for files.
  """
  alias SbCascade.Content.File

  @doc """
  Renders a list of files.
  """
  def index(%{files: files}) do
    %{data: for(file <- files, do: data(file))}
  end

  @doc """
  Renders a single file.
  """
  def show(%{file: file}) do
    %{data: data(file)}
  end

  @doc """
  Formats a file record for JSON.
  """
  def data(%File{} = file) do
    %{
      id: file.id,
      name: file.name,
      url: file.url
    }
  end
end
