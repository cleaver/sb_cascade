defmodule SbCascade.Helpers.File do
  @moduledoc """
  File helper functions
  """

  def copy_file_to_upload_path(source_file, file_name) do
    destination_filename = unique_destination_filename(file_name)
    File.cp!(source_file, destination_filename)
    destination_filename
  end

  def unique_destination_filename(file_name) do
    upload_path = Application.get_env(:sb_cascade, :upload_path)

    destination_filename =
      Path.join(Application.app_dir(:sb_cascade, upload_path), Path.basename(file_name))

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

  def delete_uploaded_file(file_url) do
    file_name = URI.decode(file_url)

    Application.app_dir(:sb_cascade, Application.get_env(:sb_cascade, :upload_path))
    |> Path.join(Path.basename(file_name))
    |> File.rm!()
  end
end
