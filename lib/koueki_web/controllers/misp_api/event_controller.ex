defmodule KouekiWeb.MISPAPI.EventsController do
  use KouekiWeb, :controller

  alias Koueki.{
    Event,
    Attribute,
    Repo
  }

  alias KouekiWeb.{
    MISPAPI,
    EventsController,
    AttributeView,
    Status
  }

  alias Ecto.Changeset

  def view(conn, params) do
    EventsController.view(conn, params, as: "event.misp.json")
  end

  def create(conn, %{"Event" => params}) do
    # Pre-process for MISP inconsistency- move Attribute to attributes
    params = Event.normalise_from_misp(params)

    EventsController.create(conn, params, as: "event.misp.json")
  end

  def create(conn, params) do
    create(conn, %{"Event" => params})
  end

  @doc """
  Add a single attribute to an event

  MISP API is not *meant* to accept an array here, however
  for some reason PyMISP will send it as such. Hence we have to handle that
  """
  def add_attribute(conn, %{"event_id" => event_id, "_json" => params}) do
    # List case
    # Literally just unwrap the first element and return that,
    # Not perfect but it replicates what MISP does
    params =
      params
      |> Attribute.normalise_from_misp()
      |> List.first()
      |> Map.put("id", event_id)

    EventsController.add_attribute(conn, params, as: "attribute.wrapped.json")
  end

  def add_attribute(conn, %{"event_id" => event_id} = params) do
    # Single object case
    # We should be OK to just re-use koueki's impl here
    params =
      Attribute.normalise_from_misp(params)
      |> Map.put("id", event_id)

    EventsController.add_attribute(conn, params, as: "attribute.wrapped.json")
  end
end
