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

  scope "/instance", KouekiWeb do
    pipe_through :api

    get "/config", InstanceController, :config
  end

  scope "/auth", KouekiWeb do
    pipe_through :api

    post "/login", SessionController, :login
    post "/logout", SessionController, :logout
  end

  scope "/v1", KouekiWeb.MISPAPI do
    pipe_through :authenticated_api

    get "/events/:id", EventsController, :view
    get "/events/view/:id", EventsController, :view
    post "/events", EventsController, :create
    post "/events/add", EventsController, :create

    get "/attributes/describeTypes.json", AttributeController, :describe_types
    post "/attributes/add/:event_id", EventsController, :add_attribute

    get "/tags/view/:id", TagController, :view
    post "/tags", TagController, :create
    post "/tags/add", TagController, :create
    post "/tags/attachTagToObject", TagController, :attach

    get "/servers/getPyMISPVersion.json", ServerController, :pymisp_version
  end

  scope "/v2", KouekiWeb do
    pipe_through :authenticated_api

    get "/events/:id", EventsController, :view
    post "/events", EventsController, :create
    post "/events/:id/attributes/", EventsController, :add_attribute
    post "/events/search", EventsController, :search

    get "/attributes/types", AttributeController, :describe_types

    get "/tags/:id", TagController, :view
    post "/tags", TagController, :create
  end

  # Fallback
  scope "/", KouekiWeb do
    pipe_through :browser
    get "/*path", PageController, :index
  end
end
