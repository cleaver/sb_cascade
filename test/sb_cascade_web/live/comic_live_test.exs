defmodule SbCascadeWeb.ComicLiveTest do
  use SbCascadeWeb.ConnCase

  import Phoenix.LiveViewTest
  import SbCascade.ContentFixtures
  import SbCascade.AccountsFixtures

  @create_attrs %{
    title: "create some title",
    body: "create some body",
    slug: "create some slug",
    published: true,
    post_date: "2024-07-16",
    meta_description: "create some meta_description",
    image_alt_text: "create some image_alt_text"
  }
  @update_attrs %{
    title: "some updated title",
    body: "some updated body",
    slug: "some updated slug",
    published: false,
    post_date: "2024-07-17",
    meta_description: "some updated meta_description",
    image_alt_text: "some updated image_alt_text"
  }
  @invalid_attrs %{
    title: nil,
    body: nil,
    slug: nil,
    published: false,
    post_date: nil,
    meta_description: nil,
    image_alt_text: nil
  }

  defp create_comic(_) do
    comic = comic_fixture()
    %{comic: comic}
  end

  defp create_tag(_) do
    tag = tag_fixture()
    %{tag: tag}
  end

  describe "Index" do
    setup [:create_comic, :create_tag]

    test "lists all comics", %{conn: conn, comic: comic} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/comics")

      assert html =~ "Comics"
      assert html =~ comic.title
    end

    test "saves new comic", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/comics")

      assert index_live |> element("a", "New Comic") |> render_click() =~
               "New Comic"

      assert_patch(index_live, ~p"/comics/new")

      assert index_live
             |> form("#comic-form", comic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#comic-form", comic: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/comics")

      html = render(index_live)

      assert html =~ "Comic created successfully"
      assert html =~ "some title"
    end

    test "updates comic in listing", %{conn: conn, comic: comic} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/comics")

      assert index_live |> element("#comics-#{comic.id} a", "Edit") |> render_click() =~
               "Edit Comic"

      assert_patch(index_live, ~p"/comics/#{comic}/edit")

      assert index_live
             |> form("#comic-form", comic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#comic-form", comic: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/comics")

      html = render(index_live)
      assert html =~ "Comic updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes comic in listing", %{conn: conn, comic: comic} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/comics")

      assert index_live |> element("#comics-#{comic.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#comics-#{comic.id}")
    end
  end

  describe "Show" do
    setup [:create_comic, :create_tag]

    test "displays comic", %{conn: conn, comic: comic} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/comics/#{comic}")

      assert html =~ "Show Comic"
      assert html =~ comic.title
    end

    test "updates comic within modal", %{conn: conn, comic: comic} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/comics/#{comic}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Comic"

      assert_patch(show_live, ~p"/comics/#{comic}/show/edit")

      assert show_live
             |> form("#comic-form", comic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#comic-form", comic: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/comics/#{comic}")

      html = render(show_live)
      assert html =~ "Comic updated successfully"
      assert html =~ "some updated title"
    end
  end
end
