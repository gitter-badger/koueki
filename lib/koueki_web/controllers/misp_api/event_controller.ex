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
    AttributeView
  }

  alias Ecto.Changeset

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

  def add_attribute(conn, %{"event_id" => event_id, "_json" => params}) do
    with {event_id, ""} <- Integer.parse(event_id),
         %Event{} <- Repo.get(Event, event_id) do
      params
      |> Stream.map(&Attribute.changeset(%Attribute{event_id: event_id}, &1))
      |> Enum.split_with(fn %Changeset{} = changeset -> changeset.valid? end)
      |> case do
        {valid_attributes, []} ->
          {:ok, transaction} =
            valid_attributes
            |> Enum.reduce(
              Ecto.Multi.new(),
              fn attr, transaction ->
                # Sorry.
                key = "#{attr.changes.category}.#{attr.changes.type}.#{attr.changes.value}"
                Ecto.Multi.insert(
                  transaction,
                  key,
                  attr
                )
              end)
            |> Repo.transaction()                
          conn
          |> json(AttributeView.render("attributes.wrapped.json",
            %{attributes: Map.values(transaction)}))
 
        {_, invalid_attributes} ->
          Status.validation_error(conn, invalid_attributes)
        end 
      else
        _ -> Status.bad_request("#{event_id} is not a valid event ID")
      end
    end
end
