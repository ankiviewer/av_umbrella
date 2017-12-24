defmodule AnkiWeb.Router do
  use AnkiWeb, :router

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

  scope "/", AnkiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    get "/styleguide", PageController, :styleguide
    resources "/search", SearchController, only: [:index]
    resources "/rules", RulesController, only: [:index]
    resources "/settings", SettingsController, only: [:index]
  end

  scope "/api", AnkiWeb do
    pipe_through :api

    get "/deck", DeckController, :index
  end
end
