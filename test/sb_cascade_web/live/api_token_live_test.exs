defmodule SbCascadeWeb.ApiTokenLiveTest do
  use SbCascadeWeb.ConnCase

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  import SbCascade.AccountsFixtures

  @endpoint SbCascadeWeb.Endpoint

  describe "Access control" do
    test "redirects non-authenticated users to login", %{conn: conn} do
      {:error, {:redirect, %{to: "/users/log_in"}}} =
        conn
        |> live(~p"/admin/api_tokens")
    end

    test "redirects non-super-user to root", %{conn: conn} do
      {:error, {:redirect, %{to: "/"}}} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/admin/api_tokens")
    end
  end

  describe "Super user access" do
    test "renders the page with empty state", %{conn: conn} do
      {:ok, _view, html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/api_tokens")

      assert html =~ "API Keys"
      assert html =~ "No API keys have been created yet."
      assert html =~ "Generate API Key"
    end

    test "lists existing API tokens", %{conn: conn} do
      super_user = super_user_fixture()
      target_user = user_fixture(%{email: "api-consumer@example.com"})

      # Create a token for the target user
      SbCascade.Accounts.create_user_api_token(target_user)

      {:ok, _view, html} =
        conn
        |> log_in_user(super_user)
        |> live(~p"/admin/api_tokens")

      assert html =~ "api-consumer@example.com"
      # Should show the created date (will be today)
      assert html =~ Calendar.strftime(DateTime.utc_now(), "%b %d, %Y")
    end

    test "generates a new API key and shows it once", %{conn: conn} do
      target_user = user_fixture(%{email: "token-receiver@example.com"})

      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/api_tokens")

      # Select user and generate
      view
      |> form("#generate-form", api_key: %{user_id: target_user.id})
      |> render_submit()

      html = render(view)

      # The page should now show the generated key banner
      assert html =~ "New API Key Created"
      assert html =~ "Copy it now"
    end

    test "generated key banner disappears after dismiss", %{conn: conn} do
      target_user = user_fixture()

      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/api_tokens")

      # Generate
      view
      |> form("#generate-form", api_key: %{user_id: target_user.id})
      |> render_submit()

      assert render(view) =~ "New API Key Created"

      # Dismiss by clicking the close button
      view |> element("#dismiss-key-btn") |> render_click()

      refute render(view) =~ "New API Key Created"
    end

    test "requires selecting a user before generating", %{conn: conn} do
      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/api_tokens")

      # Submit with no user selected
      view
      |> form("#generate-form", api_key: %{user_id: ""})
      |> render_submit()

      assert render(view) =~ "Please select a user."
    end

    test "deletes an API token", %{conn: conn} do
      target_user = user_fixture(%{email: "deletable@example.com"})
      SbCascade.Accounts.create_user_api_token(target_user)

      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/api_tokens")

      # Get the stream to find the token's DOM id
      api_token = SbCascade.Accounts.list_api_tokens() |> List.first()

      view
      |> element("#api_tokens-#{api_token.id} a", "Delete")
      |> render_click()

      assert render(view) =~ "API key deleted."
      refute has_element?(view, "#api_tokens-#{api_token.id}")
    end

    test "generates an API key via UI then uses it to access the API", %{conn: conn} do
      target_user = user_fixture(%{email: "api-roundtrip@example.com"})

      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/api_tokens")

      # Generate a key through the UI
      view
      |> form("#generate-form", api_key: %{user_id: target_user.id})
      |> render_submit()

      # Extract the plaintext key from the banner
      html = render(view)
      {:ok, doc} = Floki.parse_fragment(html)
      token = doc |> Floki.find("#new-api-key-value") |> Floki.text() |> String.trim()

      refute token == "", "expected a non-empty API token to be displayed"

      # Use the extracted key to call an API endpoint
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put_req_header("accept", "application/json")
        |> get(~p"/api/pages")

      assert json_response(conn, 200)["data"] == []

      # Verify an invalid token is rejected
      conn =
        conn
        |> recycle()
        |> put_req_header("authorization", "Bearer invalid-token")
        |> put_req_header("accept", "application/json")
        |> get(~p"/api/pages")

      assert response(conn, 401)
    end
  end
end
