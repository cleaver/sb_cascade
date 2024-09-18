defmodule SbCascadeWeb.SiteLiveTest do
  use SbCascadeWeb.ConnCase

  import Phoenix.LiveViewTest
  import SbCascade.SiteFixtures
  import SbCascade.AccountsFixtures

  @create_attrs %{
    site_title: "some name",
    meta_title: "some meta title",
    meta_description: "some meta description"
  }
  @update_attrs %{
    site_title: "some updated name",
    meta_title: "some updated meta title",
    meta_description: "some updated meta description"
  }
  @invalid_attrs %{site_title: nil, meta_title: nil, meta_description: nil}

  describe "Site Settings" do
    test "saves new settings_group", %{conn: conn} do
      {:ok, view, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/site_settings")

      assert html =~ "Site Settings"

      assert view
             |> form("#site-settings-form", settings_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert view
             |> form("#site-settings-form", settings_group: @create_attrs)
             |> render_submit()

      assert_patch(view, ~p"/site_settings")

      html = render(view)
      assert html =~ "Settings saved successfully."
      assert html =~ "some name"
    end

    test "updates settings_group", %{conn: conn} do
      _settings_group_fixture = settings_group_fixture()

      {:ok, view, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/site_settings")

      assert html =~ "some title"

      assert view
             |> form("#site-settings-form", settings_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert view
             |> form("#site-settings-form", settings_group: @update_attrs)
             |> render_submit()

      assert_patch(view, ~p"/site_settings")

      html = render(view)
      assert html =~ "Settings saved successfully."
      assert html =~ "some updated name"
    end
  end
end
