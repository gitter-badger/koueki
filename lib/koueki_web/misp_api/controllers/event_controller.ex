defmodule KouekiWeb.MISPAPI.EventsController do
  use KouekiWeb, :controller

  alias Koueki.{
    Event,
    Attribute,
    Repo
  }

  alias KouekiWeb.{
    ErrorFormatter,
    MISPAPI
  }

  def create(conn, %{"Event" => params}) do
    # Pre-process for MISP inconsistency- move Attribute to attributes
    params =
      params
      |> Map.put("attributes", Map.get(params, "Attribute", []))

    event = Event.changeset(params)

    if event.valid? do
      with {:ok, event} <- Repo.insert(event) do
        conn
        |> put_status(201)
        |> json(MISPAPI.EventView.render("event.json", event))
      else
        err ->
          IO.inspect err
          conn
          |> put_status(500)
          |> json(%{error: "Something happened when inserting event!"})
      end
    else
      # Base event invalid, do nothing
      conn
      |> put_status(400)
      |> json(%{error: ErrorFormatter.format_validation_error(event)})
    end
  end

  def create(conn, _) do
    conn
    |> put_status(400)
    |> json(%{error: "MISP API expect event creation to be wrapped in 'Event'"})
  end
end
