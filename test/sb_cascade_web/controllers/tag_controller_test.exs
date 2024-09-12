defmodule SbCascadeWeb.Api.TagControllerTest do
  @moduledoc """
  Tests for the tag API controller.
  """
  use SbCascadeWeb.ConnCase

  import SbCascade.ContentFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tags", %{conn: conn} do
      conn = get(conn, ~p"/api/tags")
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all slugs", %{conn: conn} do
      tag = tag_fixture()
      conn = get(conn, ~p"/api/tags?select=slug")

      assert json_response(conn, 200)["data"] == [tag.slug]
    end
  end

  describe "show" do
    test "returns a single tag", %{conn: conn} do
      tag = tag_fixture()
      conn = get(conn, ~p"/api/tags/#{tag.slug}")

      assert json_response(conn, 200)["data"] == %{
               "id" => tag.id,
               "slug" => tag.slug,
               "name" => tag.name,
               "comics" => []
             }
    end
  end

  test "returns a 404 for a missing tag", %{conn: conn} do
    conn = get(conn, ~p"/api/tags/missing")
    assert json_response(conn, 404)["errors"] == %{"detail" => "Not Found"}
  end
end
