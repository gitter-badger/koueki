defmodule KouekiWeb.CommonAPI.InstanceController do
  use KouekiWeb, :controller

  alias KouekiWeb.{
    ConfigView
  }

  def config(conn, _) do
    json(conn, ConfigView.render("config.json", Application.get_env(:koueki, :instance)))
  end
end
