defmodule SbCascadeWeb.Api.ComicControllerTest do
  @moduledoc """
  Tests for the comic API controller.
  """
  use SbCascadeWeb.ConnCase

  import SbCascade.ContentFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all comics", %{conn: conn} do
      conn = get(conn, ~p"/api/comics")
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all slugs", %{conn: conn} do
      comic = comic_fixture()
      conn = get(conn, ~p"/api/comics?select=slug")

      assert json_response(conn, 200)["data"] == [comic.slug]
    end

    test "paginates comics", %{conn: conn} do
      comic_fixtures =
        Enum.map(1..10, fn _ ->
          comic_fixture()
        end)

      conn = get(conn, ~p"/api/comics?page=1&page_size=5")
      assert response_data = json_response(conn, 200)["data"]
      assert length(response_data) == 5
      assert Enum.at(response_data, 0)["slug"] == hd(comic_fixtures).slug
      assert Enum.at(response_data, 4)["slug"] == Enum.at(comic_fixtures, 4).slug

      conn = get(conn, ~p"/api/comics?page=2&page_size=5")
      assert response_data = json_response(conn, 200)["data"]
      assert length(response_data) == 5
      assert Enum.at(response_data, 0)["slug"] == Enum.at(comic_fixtures, 5).slug
      assert Enum.at(response_data, 4)["slug"] == Enum.at(comic_fixtures, 9).slug

      conn = get(conn, ~p"/api/comics?page=3&page_size=5")
      assert response_data = json_response(conn, 200)["data"]
      assert length(response_data) == 0
    end
  end

  describe "show" do
    test "returns a single comic", %{conn: conn} do
      comic = comic_fixture() |> SbCascade.Repo.preload([:media, :comic_tags, :tags])
      conn = get(conn, ~p"/api/comics/#{comic.slug}")

      assert json_response(conn, 200)["data"] == %{
               "id" => comic.id,
               "slug" => comic.slug,
               "title" => comic.title,
               "body" => comic.body,
               "image_alt_text" => comic.image_alt_text,
               "media_id" => comic.media_id,
               "media" => %{
                 "id" => comic.media.id,
                 "name" => comic.media.name,
                 "url" => comic.media.url
               },
               "meta_description" => comic.meta_description,
               "post_date" => Date.to_string(comic.post_date),
               "published" => comic.published,
               "tags" => comic.tags
             }
    end
  end

  test "returns a 404 for a missing comic", %{conn: conn} do
    conn = get(conn, ~p"/api/comics/missing")
    assert json_response(conn, 404)["errors"] == %{"detail" => "Not Found"}
  end
end
