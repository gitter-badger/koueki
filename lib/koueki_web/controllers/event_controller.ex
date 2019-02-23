defmodule KouekiWeb.EventsController do
  use KouekiWeb, :controller

  import Ecto.Query

  alias Koueki.{
    Event,
    Attribute,
    Repo
  }

  alias KouekiWeb.{
    EventView,
    Status,
    User,
    Utils,
    AttributeView
  }

  def view(conn, %{"id" => id}, opts \\ []) do
    with %Event{} = event <- Repo.get(Event, id) do
      event = Event.load_assoc(event)

      conn
      |> json(
        EventView.render(
          Keyword.get(opts, :as, "event.json"),
          %{event: event}
        )
      )
    else
      _ -> Status.not_found(conn, "Event #{id} not found")
    end
  end

  def create(conn, %{} = params, opts \\ []) do
    user = Utils.get_user(conn)
    params = Map.put(params, "org_id", user.org_id)

    event = Event.changeset(%Event{}, params)

    if event.valid? do
      with {:ok, event} <- Repo.insert(event) do
        event = Event.load_assoc(event)

        conn
        |> put_status(201)
        |> json(EventView.render(Keyword.get(opts, :as, "event.json"), %{event: event}))
      else
        err ->
          IO.inspect(err)
          Status.internal_error(conn, "Error inserting event")
      end
    else
      Status.validation_error(conn, event)
    end
  end

  @doc """
  Add one or many attributes to an event

  If you post a raw JSON array, phoenix will cast to to the _json parameter
  """
  def add_attribute(conn, %{"id" => event_id, "_json" => params}, opts \\ [])
      when is_list(params) do
    with %Event{} = event <- Repo.get(Event, event_id),
         {event_id, ""} <- Integer.parse(event_id) do
      params
      |> Stream.map(&Attribute.changeset(%Attribute{event_id: event_id}, &1))
      |> Enum.split_with(fn %Ecto.Changeset{} = changeset -> changeset.valid? end)
      |> case do
        {valid_attributes, []} ->
          {:ok, transaction} =
            valid_attributes
            |> Enum.uniq_by(fn attr ->
              {attr.changes.category, attr.changes.type, attr.changes.value}
            end)
            |> Enum.reduce(
              Ecto.Multi.new(),
              fn attr, transaction ->
                # This is dirty but actually ensures uniqueness pre-DB
                key = "#{attr.changes.category}.#{attr.changes.type}.#{attr.changes.value}"

                Ecto.Multi.insert(
                  transaction,
                  key,
                  attr
                )
              end
            )
            |> Repo.transaction()

          conn
          |> put_status(201)
          |> json(
            AttributeView.render(
              Keyword.get(opts, :as, "attributes.json"),
              %{attributes: Map.values(transaction)}
            )
          )

        {_, invalid_attributes} ->
          Status.validation_error(conn, invalid_attributes)
      end
    else
      _ -> Status.not_found(conn, "Event #{event_id} not found")
    end
  end

  def add_attribute(conn, %{"id" => event_id} = params, opts) do
    # In the case that we get a single object,
    # We don't want to just return an array by using our other function,
    # we want to return the created object. Luckily this is quite easy.
    with %Event{} = event <- Repo.get(Event, event_id) do
      changeset = Attribute.changeset(%Attribute{}, params)

      if changeset.valid? do
        case Repo.insert(changeset) do
          {:ok, attribute} ->
            conn
            |> put_status(201)
            |> json(
              AttributeView.render(
                Keyword.get(opts, :as, "attribute.json"),
                %{attribute: attribute}
              )
            )

          {:error, changeset} ->
            Status.validation_error(conn, changeset)
        end
      else
        Status.validation_error(conn, changeset)
      end
    end
  end
end
