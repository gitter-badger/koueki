defmodule KouekiWeb.Plugs.APIKeyPlug do
  import Plug.Conn
  import Ecto.Query

  alias Koueki.{
    User,
    Repo
  }

  def init(options) do
    options
  end

  def call(conn, _) do
    with [auth_header] <- get_req_header(conn, "authorization"),
         %User{} = user <-
           Repo.one(from user in User, where: user.apikey == ^auth_header, preload: [:org, :role]) do
      conn
      |> assign(:user, user)
    else
      _ -> conn
    end
  end
end
