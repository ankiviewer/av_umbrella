defmodule AvWeb.Router do
  use AvWeb, :router

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

  pipeline :with_session do
    plug AvWeb.Auth.Pipeline
    plug AvWeb.Auth.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", AvWeb do
    pipe_through [:browser, :with_session]

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    scope "/" do
      pipe_through :login_required

      get "/", HomeController, :index
      get "/rules", RulesController, :index
      get "/search", SearchController, :index
      get "/settings", SettingsController, :index
    end
  end

  scope "/api", AvWeb do
    pipe_through :api
    # TODO: add auth

    get "/deck", HomeController, :updated_at
    get "/collection", SearchController, :collection
    get "/notes", SearchController, :notes
    post "/rules_sync", RulesController, :rules_sync
  end
end
