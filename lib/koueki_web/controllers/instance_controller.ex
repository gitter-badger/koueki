defmodule KouekiWeb.InstanceController do
  use KouekiWeb, :controller

  alias Koueki.{
    Org,
    Repo
  }

  alias KouekiWeb.{
    ConfigView
  }

  def config(conn, _) do
    json(conn, ConfigView.render("config.json", Application.get_env(:koueki, :instance)))
  end

  def check_credentials(conn, _) do
    json(conn, %{ok: true})
  end

  @doc """
  Return the owner organisation for setting up sync
  """
  def owner(conn, _) do
    with %Org{} = org <- Repo.get_by(Org, local: true) do
      conn
      |> json(KouekiWeb.OrgView.render("org.json", %{org: org}))
    else
      nil ->
        conn
        |> put_status(404)
        |> json(%{"error" => "No local organisation"})
    end
  end
end
