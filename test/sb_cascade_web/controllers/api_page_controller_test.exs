defmodule SbCascadeWeb.Api.PageControllerTest do
  @moduledoc """
  Tests for the page API controller.
  """
  use SbCascadeWeb.ConnCase

  import SbCascade.AccountsFixtures
  import SbCascade.ContentFixtures
  import SbCascadeWeb.Helpers.Api

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all pages", %{conn: conn} do
      {_user, token} = api_user_fixture()
      conn = authenticated_request(conn, token, ~p"/api/pages")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "returns a single page", %{conn: conn} do
      {_user, token} = api_user_fixture()
      page = page_fixture() |> SbCascade.Repo.preload([:media])
      conn = authenticated_request(conn, token, ~p"/api/pages/#{page.slug}")

      stringified_test_media =
        page.media
        |> SbCascadeWeb.Api.FileJSON.data()
        |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)

      assert json_response(conn, 200)["data"] == %{
               "id" => page.id,
               "slug" => page.slug,
               "title" => page.title,
               "body" => page.body,
               "media" => stringified_test_media,
               "meta_description" => page.meta_description,
               "image_alt_text" => page.image_alt_text
             }
    end
  end

  test "returns a 404 for a missing page", %{conn: conn} do
    {_user, token} = api_user_fixture()
    conn = authenticated_request(conn, token, ~p"/api/pages/missing")
    assert json_response(conn, 404)["errors"] == %{"detail" => "Not Found"}
  end
end
