defmodule KouekiWeb.EventsController do
  use KouekiWeb, :controller

  def test(conn, _) do
    conn
    |> json(%{ok: true})
  end
end
