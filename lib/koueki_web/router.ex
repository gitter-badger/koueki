defmodule KouekiWeb.Router do
  use KouekiWeb, :router

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

  pipeline :authenticated_api do
    plug :accepts, ["json"]
    plug KouekiWeb.Plugs.SessionCookiePlug
    plug KouekiWeb.Plugs.APIKeyPlug
    plug KouekiWeb.Plugs.EnsureAuthenticatedPlug
  end

  scope "/", KouekiWeb do
    pipe_through :browser
    get "/", PageController, :index
  end


  scope "/auth", KouekiWeb do
    pipe_through :api        
    
    post "/login", SessionController, :login
  end

  scope "/events", KouekiWeb do
    pipe_through :authenticated_api

    get "/", EventsController, :test
  end

  # Fallback
  scope "/", KouekiWeb do
    pipe_through :browser
    get "/*path", PageController, :index
  end
end
