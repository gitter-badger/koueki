defmodule KouekiWeb.ServerController do
  use KouekiWeb, :controller
  
  import Ecto.Query

  alias Koueki.{
    Server
  }

  alias KouekiWeb.{
    ServerView,
    Status
  }

  def list(conn, _) do
    servers = 
      from(server in Server, preload: [:org])
      |> Repo.all()
    conn
    |> json(ServerView.render("servers.json", %{servers: servers}))
  end

  def create(conn, params) do
    changeset = Server.changeset(%Server{}, params)

    if changeset.valid? do
      {:ok, server} = Repo.insert(changeset)
      conn  
      |> put_status(201)
      |> json(Server.render("server.json", %{server: server}))
    else
      Status.validation_error(conn, changeset)
    end
  end 
end
