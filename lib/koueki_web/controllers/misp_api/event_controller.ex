defmodule KouekiWeb.MISPAPI.EventsController do
  use KouekiWeb, :controller

  alias Koueki.{
    Event,
    Attribute,
    Repo
  }

  alias KouekiWeb.{
    MISPAPI,
    EventsController
  }

  def view(conn, params) do
    EventsController.view(conn, params, "event.misp.json")
  end

  def create(conn, %{"Event" => params}) do
    # Pre-process for MISP inconsistency- move Attribute to attributes
    params =
      params
      |> Map.put("attributes", Map.get(params, "Attribute", []))
      |> Map.put("tags", Map.get(params, "Tag", []))

    # Now sadly we have to do the same for attribute -> tag
    attributes =
      params
      |> Map.get("attributes")
      |> Enum.map(fn attribute ->
        attribute
        |> Map.put("tags", Map.get(attribute, "Tag", []))
      end)

    params = Map.put(params, "attributes", attributes)

    EventsController.create(conn, params, "event.misp.json")
  end

  def create(conn, params) do
    create(conn, %{"Event" => params})
  end
end
