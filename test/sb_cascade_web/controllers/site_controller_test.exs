defmodule SbCascadeWeb.Api.SiteControllerTest do
  @moduledoc """
  Tests for the site setting API controller.
  """
  use SbCascadeWeb.ConnCase

  import SbCascade.AccountsFixtures
  import SbCascade.SiteFixtures
  import SbCascadeWeb.Helpers.Api

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all settings", %{conn: conn} do
      {_user, token} = api_user_fixture()
      conn = authenticated_request(conn, token, ~p"/api/settings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "returns a single setting", %{conn: conn} do
      {_user, token} = api_user_fixture()
      setting = setting_fixture()
      conn = authenticated_request(conn, token, ~p"/api/settings/#{setting.key}")

      assert json_response(conn, 200)["data"] == %{
               "id" => setting.id,
               "key" => setting.key,
               "value" => setting.value,
               "inserted_at" => setting.inserted_at |> DateTime.to_iso8601(),
               "updated_at" => setting.updated_at |> DateTime.to_iso8601()
             }
    end
  end

  test "returns a 404 for a missing setting", %{conn: conn} do
    {_user, token} = api_user_fixture()
    conn = authenticated_request(conn, token, ~p"/api/settings/missing")
    assert json_response(conn, 404)["errors"] == %{"detail" => "Not Found"}
  end
end
