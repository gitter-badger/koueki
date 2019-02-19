defmodule KouekiWeb.SessionController do
  use KouekiWeb, :controller

  alias Koueki.{
    User,
    Repo
  }

  defp access_denied(conn) do
    conn
    |> put_status(403)
    |> json(%{error: "Invalid credentials"})
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- Repo.get_by(User, email: email) do
      if User.verify_password(user, password) do
        conn  
        |> fetch_session()
        |> put_session(:user_id, user.id)
        |> json(%{ok: true})
      else
        access_denied(conn)
      end
    else
      _ -> access_denied(conn)
    end
  end

  def login(conn, _) do
    conn
    |> put_status(400)
    |> json(%{error: "Both email and password are required to log in!"})
  end  
end
