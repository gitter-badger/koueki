defmodule KouekiWeb.MISPAPI.AttributeController do
  use KouekiWeb, :controller

  alias Koueki.Attribute.{
    Type,
    Category
  }

  alias KouekiWeb.{
    DescribeTypeView
  }

  @doc """
  Behold, the gates of hell themselves!

  Please for the love of all that is holy do NOT ask why
  MISP uses this
  """
  def describe_types(conn, _) do
    types = Type.types()

    conn
    |> json(%{
      result: %{
        types: Map.keys(types),
        categories: Category.categories(),
        sane_defaults: DescribeTypeView.render("sane_defaults.json", types),
        category_type_mappings: DescribeTypeView.render("type_mapping.json", types)
      }
    })
  end
end
