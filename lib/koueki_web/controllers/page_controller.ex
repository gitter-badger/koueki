defmodule KouekiWeb.PageController do
  use KouekiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def redirect_to_web(conn, _) do
    redirect(conn, to: "/web/")
  end
end
