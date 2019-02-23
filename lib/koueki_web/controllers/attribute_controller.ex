defmodule KouekiWeb.AttributeController do
  use KouekiWeb, :controller

  def describe_types(conn, _) do
    conn
    |> json(Koueki.Attribute.Type.types())
  end
end
