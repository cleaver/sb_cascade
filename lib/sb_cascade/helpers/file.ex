defmodule SbCascade.Helpers.File do
  @moduledoc """
  File helper functions
  """

  def upload_path do
    Application.get_env(:sb_cascade, :uploads_path)
  end

  def full_upload_path do
    app_dir = File.cwd!()
    uploads_dir = Application.get_env(:sb_cascade, :uploads_path)
    Path.join([app_dir, uploads_dir])
  end

  def full_upload_path([path]), do: full_upload_path(path)

  def full_upload_path(path) do
    # Decode URL-encoded characters
    decoded_path = URI.decode(path)

    case Path.safe_relative(decoded_path, full_upload_path()) do
      {:ok, safe_path} -> Path.join(full_upload_path(), safe_path)
      :error -> raise "Invalid path: #{path}"
    end
  end

  def copy_file_to_upload_path(source_file, file_name) do
    destination_filename = unique_destination_filename(file_name)
    File.cp!(source_file, destination_filename)
    destination_filename
  end

  def unique_destination_filename(file_name) do
    destination_filename = Path.join(full_upload_path(), Path.basename(file_name))

    if File.exists?(destination_filename) do
      file_name
      |> increment_filename()
      |> unique_destination_filename()
    else
      destination_filename
    end
  end

  defp increment_filename(file_name) do
    case Regex.run(~r/^(.+)_(\d+)$/, Path.rootname(file_name)) do
      [_, base, num] ->
        new_num = String.to_integer(num) + 1
        "#{base}_#{new_num}#{Path.extname(file_name)}"

      _ ->
        "#{Path.rootname(file_name)}_1#{Path.extname(file_name)}"
    end
  end

  def delete_uploaded_file(nil), do: nil

  def delete_uploaded_file(file_url) do
    file_path = URI.decode(file_url)

    full_upload_path()
    |> Path.join(Path.basename(file_path))
    |> File.rm()
  end
end
