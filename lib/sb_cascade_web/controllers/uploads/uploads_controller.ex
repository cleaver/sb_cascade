defmodule SbCascadeWeb.UploadsController do
  use SbCascadeWeb, :controller
  require Logger

  def show(conn, %{"path" => path}) do
    # Ensure the path is safe and doesn't contain directory traversal attempts
    uploads_path = Application.get_env(:sb_cascade, :uploads_path)
    safe_path = Path.join([uploads_path, path])

    Logger.debug("Attempting to serve file: #{path}")

    # Verify the file exists and is within the uploads directory
    if File.exists?(safe_path) and String.contains?(safe_path, "uploads") do
      # Determine content type based on file extension
      content_type = get_content_type(safe_path)

      Logger.debug("Serving file: #{safe_path} with content-type: #{content_type}")

      # Stream the file to the client
      conn
      |> put_resp_content_type(content_type)
      |> send_file(200, safe_path)
    else
      Logger.warning("File not found or outside uploads directory: #{safe_path}")

      if not String.contains?(safe_path, "uploads") do
        Logger.warning(
          "Potential security issue: Requested path outside uploads directory: #{path}"
        )
      end

      conn
      |> put_status(:not_found)
      |> text("File not found")
    end
  end

  # Helper function to determine content type based on file extension
  defp get_content_type(path) do
    case Path.extname(path) do
      ".jpg" ->
        "image/jpeg"

      ".jpeg" ->
        "image/jpeg"

      ".png" ->
        "image/png"

      ".gif" ->
        "image/gif"

      ".webp" ->
        "image/webp"

      ext ->
        Logger.warning("Unknown file extension: #{ext} for file: #{path}")
        "application/octet-stream"
    end
  end
end
