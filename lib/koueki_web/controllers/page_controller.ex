defmodule KouekiWeb.PageController do
  use KouekiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
