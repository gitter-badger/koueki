defmodule KouekiWeb.ServerController do
  use KouekiWeb, :controller

  import Ecto.Query

  alias Koueki.{
    Server,
    Repo
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
      |> json(ServerView.render("server.json", %{server: server}))
    else
      Status.validation_error(conn, changeset)
    end
  end

  def pull_orgs(conn, params) do
    changeset = Server.no_save_changeset(%Server{}, params)

    if changeset.valid? do
      result = Server.maybe_get_remote_org(changeset.changes)

      case result do
        {:ok, orgs} ->
          conn |> json(%{"ok" => true, "message" => "Pulled #{Enum.count(orgs)} orgs"})

        {:error, :permission_denied} ->
          Status.permission_denied(conn, "Provided credentials were incorrect!")
      end
    else
      Status.validation_error(conn, changeset)
    end
  end
end
