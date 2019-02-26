defmodule KouekiWeb.InstanceController do
  use KouekiWeb, :controller

  alias KouekiWeb.{
    ConfigView
  }

  def config(conn, _) do
    json(conn, ConfigView.render("config.json", Application.get_env(:koueki, :instance)))
  end

  def check_credentials(conn, _) do
    json(conn, %{ok: true})
  end
end
