defmodule SbCascadeWeb.Router do
  use SbCascadeWeb, :router

  import SbCascadeWeb.UserAuth
  import SbCascadeWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SbCascadeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :assign_current_path
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_api_user
  end

  scope "/", SbCascadeWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", SbCascadeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sb_cascade, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SbCascadeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## API routes
  scope "/api", SbCascadeWeb do
    pipe_through :api

    get "/comics", Api.ComicController, :index
    get "/comics/_count", Api.ComicController, :count
    get "/comics/:slug", Api.ComicController, :show

    get "/tags", Api.TagController, :index
    get "/tags/:slug", Api.TagController, :show

    get "/pages", Api.PageController, :index
    get "/pages/:slug", Api.PageController, :show

    get "/settings", Api.SiteController, :index
    get "/settings/:setting", Api.SiteController, :show
  end

  ## Authentication routes

  scope "/", SbCascadeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SbCascadeWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SbCascadeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SbCascadeWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/comics", ComicLive.Index, :index
      live "/comics/new", ComicLive.Index, :new
      live "/comics/:id/edit", ComicLive.Index, :edit

      live "/comics/:id", ComicLive.Show, :show
      live "/comics/:id/show/edit", ComicLive.Show, :edit

      live "/files", FileLive.Index, :index
      live "/files/new", FileLive.Index, :new
      live "/files/:id/edit", FileLive.Index, :edit

      live "/files/:id", FileLive.Show, :show
      live "/files/:id/show/edit", FileLive.Show, :edit

      live "/pages", PageLive.Index, :index
      live "/pages/new", PageLive.Index, :new
      live "/pages/:id/edit", PageLive.Index, :edit

      live "/pages/:id", PageLive.Show, :show
      live "/pages/:id/show/edit", PageLive.Show, :edit

      live "/tags", TagLive.Index, :index
      live "/tags/new", TagLive.Index, :new
      live "/tags/:id/edit", TagLive.Index, :edit

      live "/tags/:id", TagLive.Show, :show
      live "/tags/:id/show/edit", TagLive.Show, :edit

      live "/site_settings", SiteLive.Settings, :edit
    end
  end

  scope "/", SbCascadeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{SbCascadeWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
