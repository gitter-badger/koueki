defmodule KouekiWeb.MISPAPI.ServerController do
  use KouekiWeb, :controller

  def pymisp_version(conn, _) do
    json(conn, %{version: "2.4.102"})
  end
end
