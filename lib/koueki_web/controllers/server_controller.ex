defmodule KouekiWeb.ServerController do
  use KouekiWeb, :controller

  import Ecto.Query

  alias Koueki.{
    Server,
    Repo
  }

  alias KouekiWeb.{
    ServerView,
    Status,
    Utils
  }

  @doc """
  List all sync server owned by the user's organisation
  """
  def list(conn, _) do
    user = Utils.get_user(conn)

    servers =
      from(server in Server,
        preload: [:org],
        where: server.org_id == ^user.org_id
      )
      |> Repo.all()

    conn
    |> json(ServerView.render("servers.json", %{servers: servers}))
  end

  def create(conn, params) do
    user = Utils.get_user(conn)

    params = Map.put(params, "org_id", user.org_id)

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
end
