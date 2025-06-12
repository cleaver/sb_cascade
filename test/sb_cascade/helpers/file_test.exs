defmodule SbCascade.Helpers.FileTest do
  use ExUnit.Case
  alias SbCascade.Helpers.File

  describe "full_upload_path/1" do
    test "handles normal file paths correctly" do
      path = "test.jpg"
      result = File.full_upload_path(path)
      assert String.ends_with?(result, path)
    end

    test "handles valid subdirectory paths" do
      path = "subdir/test.jpg"
      result = File.full_upload_path(path)

      assert String.ends_with?(
               result,
               Path.join(Application.get_env(:sb_cascade, :uploads_path), path)
             )
    end

    test "raises error for directory traversal with ../" do
      path = "../../../etc/passwd"

      assert_raise RuntimeError, "Invalid path: #{path}", fn ->
        File.full_upload_path(path)
      end
    end

    test "handles backslashes appropriately for platform" do
      case :os.type() do
        {:win32, _} ->
          # On Windows, backslash directory traversal should fail
          path = "..\\..\\..\\etc\\passwd"

          assert_raise RuntimeError, "Invalid path: #{path}", fn ->
            File.full_upload_path(path)
          end

        _ ->
          # On Unix, backslashes are just characters in filenames
          path = "file\\with\\backslashes.jpg"
          result = File.full_upload_path(path)
          assert String.ends_with?(result, path)
      end
    end

    test "raises error for directory traversal with encoded characters" do
      path = "%2e%2e%2f%2e%2e%2f%2e%2e%2fetc%2fpasswd"

      assert_raise RuntimeError, "Invalid path: #{path}", fn ->
        File.full_upload_path(path)
      end
    end

    test "raises error for multiple directory traversal attempts" do
      path = "subdir/../../../etc/passwd"

      assert_raise RuntimeError, "Invalid path: #{path}", fn ->
        File.full_upload_path(path)
      end
    end

    test "raises error for absolute paths" do
      path = "/etc/passwd"

      assert_raise RuntimeError, "Invalid path: #{path}", fn ->
        File.full_upload_path(path)
      end
    end
  end
end
