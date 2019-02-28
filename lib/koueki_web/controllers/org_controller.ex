defmodule KouekiWeb.OrgController do
  use KouekiWeb, :controller
  import Ecto.Query

  alias Koueki.{
    Org,
    Repo
  }

  alias KouekiWeb.{
    OrgView
  }

  def list(conn, _) do
    orgs =
      from(org in Org)
      |> Repo.all()

    conn
    |> json(OrgView.render("orgs.json", %{orgs: orgs}))
  end
end
