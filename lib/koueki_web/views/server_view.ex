defmodule KouekiWeb.ServerView do
  use KouekiWeb, :view

  def render("servers.json", %{servers: servers}) do
    render_many(servers, KouekiWeb.ServerView, "server.json")
  end

  def render("server.json", %{server: server}) do
    %{
      id: server.id,
      name: server.name,
      uuid: server.uuid,
      url: server.url,
      last_sync: server.last_sync,
    }
  end
end
