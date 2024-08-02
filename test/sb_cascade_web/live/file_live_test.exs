defmodule SbCascadeWeb.FileLiveTest do
  use SbCascadeWeb.ConnCase

  import Phoenix.LiveViewTest
  import SbCascade.ContentFixtures
  import SbCascade.AccountsFixtures

  @create_attrs %{name: "some name", width: 42, url: "some url", height: 42}
  @update_attrs %{name: "some updated name", width: 43, url: "some updated url", height: 43}
  @invalid_attrs %{name: nil, width: nil, url: nil, height: nil}

  defp create_file(_) do
    file = file_fixture()
    %{file_fixture: file}
  end

  describe "Index" do
    setup [:create_file]

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
