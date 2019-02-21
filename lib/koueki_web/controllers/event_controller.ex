defmodule KouekiWeb.EventsController do
  use KouekiWeb, :controller

  import Ecto.Query

  alias Koueki.{
    Event,
    Repo
  }

  alias KouekiWeb.{
    EventView,
    Status
  }

  def view(conn, %{"id" => id}, render_as \\ "event.json") do
    with %Event{} = event <- Repo.get(Event, id) do
      event = Event.load_assoc(event)

      conn
      |> json(EventView.render(render_as, %{event: event})) 
    else
      _ -> Status.not_found(conn, "Event #{id} not found")
    end
  end

  def create(conn, %{} = params, render_as \\ "event.json") do
    event = Event.changeset(params)

    if event.valid? do
      with {:ok, event} <- Repo.insert(event) do
        event = Event.load_assoc(event)        

        conn
        |> put_status(201)
        |> json(EventView.render(render_as, %{event: event}))
      else
        err ->
          IO.inspect err
          Status.internal_error(conn, "Error inserting event")
      end
    else
      Status.validation_error(conn, event)
    end
  end
end
