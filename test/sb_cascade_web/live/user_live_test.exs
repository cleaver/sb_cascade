defmodule SbCascadeWeb.UserLiveTest do
  use SbCascadeWeb.ConnCase

  import Phoenix.LiveViewTest
  import SbCascade.AccountsFixtures

  @create_attrs %{
    email: "newadmin@example.com",
    password: "valid password 123",
    super_user: true
  }
  @update_attrs %{
    email: "updated@example.com",
    super_user: false
  }
  @invalid_attrs %{email: nil, password: nil}

  describe "Access control" do
    test "redirects non-authenticated users to login", %{conn: conn} do
      {:error, {:redirect, %{to: "/users/log_in"}}} =
        conn
        |> live(~p"/admin/users")
    end

    test "redirects non-super-user to root", %{conn: conn} do
      {:error, {:redirect, %{to: "/"}}} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/admin/users")
    end
  end

  describe "Super user access" do
    test "lists all users", %{conn: conn} do
      user = user_fixture()

      {:ok, _view, html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/users")

      assert html =~ "Users"
      assert html =~ user.email
      assert html =~ "<svg"
      assert html =~ "viewBox=\"0 0 24 24\""
    end

    test "saves new user", %{conn: conn} do
      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/users")

      assert view |> element("a", "New User") |> render_click() =~ "New User"
      assert_patch(view, ~p"/admin/users/new")

      assert view
             |> form("#user-form", user: @invalid_attrs)
             |> render_submit() =~ "can&#39;t be blank"

      view
      |> form("#user-form", user: @create_attrs)
      |> render_submit()

      assert_patch(view, ~p"/admin/users")

      html = render(view)
      assert html =~ "User created successfully."
      assert html =~ "newadmin@example.com"
    end

    test "shows edit form for existing user", %{conn: conn} do
      user = user_fixture()

      {:ok, _view, html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/users/#{user.id}/edit")

      assert html =~ "Edit User"
      assert html =~ user.email
    end

    test "updates user", %{conn: conn} do
      user = user_fixture()

      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/users/#{user.id}/edit")

      assert view
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      view
      |> form("#user-form", user: @update_attrs)
      |> render_submit()

      assert_patch(view, ~p"/admin/users")

      html = render(view)
      assert html =~ "User updated successfully."
      assert html =~ "updated@example.com"
    end

    test "cannot delete own account", %{conn: conn} do
      super_user = super_user_fixture()

      {:ok, view, _html} =
        conn
        |> log_in_user(super_user)
        |> live(~p"/admin/users")

      view
      |> element("#users-#{super_user.id} a", "Delete")
      |> render_click()

      assert render(view) =~ "You cannot delete your own account."
    end

    test "deletes other user", %{conn: conn} do
      super_user_fixture()
      target = user_fixture()

      {:ok, view, _html} =
        conn
        |> log_in_user(super_user_fixture())
        |> live(~p"/admin/users")

      view
      |> element("#users-#{target.id} a", "Delete")
      |> render_click()

      refute has_element?(view, "#users-#{target.id}")
    end
  end
end
