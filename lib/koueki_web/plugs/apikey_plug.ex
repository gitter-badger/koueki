defmodule KouekiWeb.Plugs.APIKeyPlug do
  import Plug.Conn

  alias Koueki.{
    User,
    Repo
  }

  def init(options) do
    options
  end

  def call(conn, _) do
    with [auth_header] <- get_req_header(conn, "authorization"),
         %User{} = user <- Repo.get_by(User, apikey: auth_header) do
      conn
      |> assign(:user, user)
    else
      _ -> conn
    end
  end
end
