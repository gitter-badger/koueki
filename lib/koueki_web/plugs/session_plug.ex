defmodule KouekiWeb.Plugs.SessionCookiePlug do
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
    user_id =
      conn
      |> fetch_session()
      |> get_session(:user_id)

    if user_id == nil do
      conn
    else
      conn
      |> assign(:user, Repo.one(from user in User, where: user.id == ^user_id, preload: [:org]))
    end
  end
end
