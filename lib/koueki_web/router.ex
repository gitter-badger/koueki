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

  scope "/instance", KouekiWeb.CommonAPI do
    pipe_through :api

    get "/config", InstanceController, :config
  end

  scope "/auth", KouekiWeb.CommonAPI do
    pipe_through :api

    post "/login", SessionController, :login
    post "/logout", SessionController, :logout
  end

  scope "/v1", KouekiWeb.MISPAPI do
    pipe_through :authenticated_api

    post "/events", EventsController, :create
  end

  scope "/v2", KouekiWeb.KouekiAPI do
    pipe_through :authenticated_api
  end

  # Fallback
  scope "/", KouekiWeb do
    pipe_through :browser
    get "/*path", PageController, :index
  end
end
