defmodule BloggerWeb.Router do
  use BloggerWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BloggerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: MyApp.CustomErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/articles", BloggerWeb do
    pipe_through [:browser, :protected]

    get "/new", PageController, :new
    post "/", PageController, :create

    get "/:id/edit", PageController, :edit
    patch "/:id", PageController, :update
    delete "/:id", PageController, :delete

    post "/:id/comments", CommentController, :create
    delete "/:article_id/comments/:comment_id", CommentController, :delete
  end

  scope "/", BloggerWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/articles/:id", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", BloggerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:blogger, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BloggerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
