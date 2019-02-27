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
    get "/", PageController, :redirect_to_web
  end

  scope "/web", KouekiWeb do
    pipe_through :browser
    get "/*path", PageController, :index
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

  scope "/authcheck", KouekiWeb do
    pipe_through :authenticated_api

    get "/", InstanceController, :check_credentials
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

    # Event level
    get "/events", EventsController, :list
    post "/events", EventsController, :create
    get "/events/:id", EventsController, :view
    patch "/events/:id", EventsController, :edit
    delete "/events/:id", EventsController, :delete
    post "/events/search", EventsController, :search
    get "/events/:id/tags", EventsController, :get_tags
    post "/events/:event_id/tags", EventsController, :add_tag

    # Event->Attribute level
    get "/events/:id/attributes", EventsController, :get_attributes
    post "/events/:id/attributes", EventsController, :add_attribute
    post "/events/:event_id/attributes/:id/tags", AttributeController, :add_tag

    # Attribute level
    get "/attributes/types", AttributeController, :describe_types
    get "/attributes/categories", AttributeController, :describe_categories
    post "/attributes/search", AttributeController, :search
    post "/attributes/:id/tags", AttributeController, :add_tag

    # Tag level
    get "/tags/:id", TagController, :view
    post "/tags", TagController, :create
    post "/tags/search", TagController, :search
  end
end
