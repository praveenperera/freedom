defmodule FreedomWeb.Router do
  use FreedomWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :freedom

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {FreedomWeb.LayoutView, :root}
  end

  pipeline :admin_role do
    plug FreedomWeb.Plug.EnsureRole, :admin
  end

  pipeline :active_only do
    plug FreedomWeb.Plug.EnsureStatus, :active
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    pow_routes()
    pow_extension_routes()
  end

  scope "/", FreedomWeb do
    pipe_through [:browser]
    get "/", PageController, :index
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
