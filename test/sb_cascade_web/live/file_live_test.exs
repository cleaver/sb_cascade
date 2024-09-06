defmodule SbCascadeWeb.FileLiveTest do
  @moduledoc """
  File live tests.

  `async: false` to prevent conflicts with file uploads.
  """
  use SbCascadeWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import SbCascade.ContentFixtures
  import SbCascade.AccountsFixtures

  alias SbCascade.Helpers.File, as: FileHelper

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}
  @file_name "rubber-duck-icon.png"

  defp file_upload_metadata() do
    %{
      name: @file_name,
      last_modified: 1_588_099_286,
      size: 3_239,
      type: "image/png",
      content: File.read!(Path.join("./test/support/fixtures", @file_name))
    }
  end

  defp create_file(_) do
    file = file_fixture()
    %{file_fixture: file}
  end

  defp clean_upload_directory(_) do
    File.ls!(FileHelper.upload_path())
    |> Enum.reject(&(&1 == ".keep"))
    |> Enum.each(fn file ->
      FileHelper.upload_path()
      |> Path.join(file)
      |> File.rm!()
    end)
  end

  describe "Index" do
    setup [:create_file, :clean_upload_directory]

    test "lists all files", %{conn: conn, file_fixture: file} do
      {:ok, _index_live, html} = conn |> log_in_user(user_fixture()) |> live(~p"/files")

      assert html =~ "Files"
      assert html =~ file.name
    end

    test "saves new file", %{conn: conn} do
      {:ok, index_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/files")

      assert index_live |> element("a", "New File") |> render_click() =~
               "New File"

      assert_patch(index_live, ~p"/files/new")

      assert index_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      upload_image = file_input(index_live, "#file-form", :image, [file_upload_metadata()])
      assert render_upload(upload_image, @file_name) =~ "100%"

      assert index_live
             |> form("#file-form", file: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/files")

      html = render(index_live)
      assert html =~ "File created successfully"
      assert html =~ "some name"
    end

    test "updates file in listing", %{conn: conn, file_fixture: file} do
      {:ok, index_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/files")

      assert index_live |> element("#files-#{file.id} a", "Edit") |> render_click() =~
               "Edit File"

      assert_patch(index_live, ~p"/files/#{file}/edit")

      assert index_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#file-form", file: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/files")

      html = render(index_live)
      assert html =~ "File updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes file in listing", %{conn: conn, file_fixture: file} do
      {:ok, index_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/files")

      assert index_live |> element("#files-#{file.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#files-#{file.id}")
    end
  end

  describe "Show" do
    setup [:create_file]

    test "displays file", %{conn: conn, file_fixture: file} do
      {:ok, _show_live, html} = conn |> log_in_user(user_fixture()) |> live(~p"/files/#{file}")

      assert html =~ "Show File"
      assert html =~ file.name
    end

    test "updates file within modal", %{conn: conn, file_fixture: file} do
      {:ok, show_live, _html} = conn |> log_in_user(user_fixture()) |> live(~p"/files/#{file}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit File"

      assert_patch(show_live, ~p"/files/#{file}/show/edit")

      assert show_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#file-form", file: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/files/#{file}")

      html = render(show_live)
      assert html =~ "File updated successfully"
      assert html =~ "some updated name"
    end
  end
end
