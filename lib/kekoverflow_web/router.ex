defmodule KekoverflowWeb.Router do
  use KekoverflowWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
         error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :exq do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug ExqUi.RouterPlug, namespace: "exq"
  end

  scope "/exq", ExqUi do
    pipe_through :exq
    forward "/", RouterPlug.Router, :index
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_assent_routes()
  end

  scope "/", KekoverflowWeb do
    pipe_through [:browser, :protected]

    resources "/tags", TagController
    get "/tagged/:tag", TagController, :tagged

    resources "/questions", QuestionController do
      resources "/comments", CommentController, only: [:create, :delete, :update]

      resources "/answers", AnswerController, only: [:edit, :create, :delete, :update] do
        resources "/comments", CommentController, only: [:create, :delete, :update]
      end
    end
  end

  scope "/", KekoverflowWeb do
    pipe_through [:browser]

    resources "/", WelcomeController
  end

  # Other scopes may use custom stacks.
  # scope "/api", KekoverflowWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: KekoverflowWeb.Telemetry
    end
  end
end
