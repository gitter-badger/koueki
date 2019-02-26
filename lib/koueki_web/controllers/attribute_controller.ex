defmodule KouekiWeb.AttributeController do
  use KouekiWeb, :controller

  alias Koueki.Attribute
  alias KouekiWeb.AttributeView

  def describe_types(conn, _) do
    conn
    |> json(Koueki.Attribute.Type.types())
  end

  def describe_categories(conn, _) do
    conn
    |> json(Koueki.Attribute.Category.categories())
  end

  def search(conn, params) do
    {entries, page_count} = Attribute.search(params)

    conn
    |> put_resp_header("X-Page-Count", to_string(page_count))
    |> json(AttributeView.render("attributes.json", %{attributes: entries}))
  end

  def add_tag(conn, %{"id" => id} = params) do

  end
    
end
