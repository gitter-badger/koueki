defmodule KouekiWeb.EventsController do
  use KouekiWeb, :controller

  import Ecto.Query
  import Canada, only: [can?: 2]

  alias Koueki.{
    Event,
    Attribute,
    Repo,
    User
  }

  alias KouekiWeb.{
    EventView,
    ErrorStatus,
    Utils,
    AttributeView,
    TagView
  }

  def index(conn, params) do
    page =
      from(event in Event, preload: [:org, :tags, :attributes])
      |> Repo.paginate(
        page: Map.get(params, "page", 0),
        page_size: Map.get(params, "limit", 20)
      )

    conn
    |> put_resp_header("x-page-count", to_string(page.total_pages))
    |> json(EventView.render("events.json", %{events: page.entries}))
  end

  def view(conn, %{"id" => id}, opts \\ [as: "event.json"]) do
    with %Event{} = event <- Repo.get(Event, id) do
      event = Event.load_assoc(event)

      conn
      |> json(EventView.render(opts[:as], %{event: event}))
    else
      _ -> ErrorStatus.not_found(conn, "Event #{id} not found")
    end
  end

  def create(conn, %{} = params, opts \\ [as: "event.json"]) do
    user = Utils.get_user(conn)
    params = 
      params
      |> Map.put("org", user.org)
      |> Map.put("user_id", user.id)

    if user |> can? create(%Event{}) do
      event = Event.changeset(%Event{}, params)

      if event.valid? do
        with {:ok, event} <- Repo.insert(event) do
          event = Event.load_assoc(event)

          conn
          |> put_status(201)
          |> json(EventView.render(opts[:as], %{event: event}))
        else
          err ->
            IO.inspect(err)
            ErrorStatus.internal_error(conn, "Error inserting event")
        end
      else
        ErrorStatus.validation_error(conn, event)
      end
    else
      ErrorStatus.not_allowed(conn)
    end
  end

  @doc """
  The PATCH method - should edit the event in the specified fields
  """
  def edit(conn, %{"id" => id} = params, opts \\ [as: "event.shallow.json"]) do
    with %User{} = user <- Utils.get_user(conn),
         {:query, %Event{} = event} <- {:query, Event.get_with_preload(id, [:org])},
         {:permissions, true} <- {:permissions, user |> can? edit(event)} do

      changeset = Event.edit_changeset(event, params)
      if changeset.valid? do
        {:ok, event} = Repo.update(changeset)

        conn
        |> json(EventView.render(opts[:as], %{event: event}))
      else
        ErrorStatus.validation_error(conn, changeset)
      end
    else
      {:query, nil} -> ErrorStatus.not_found(conn, "Event #{id} not found")
      {:permissions, false} -> ErrorStatus.not_allowed(conn)
    end
  end

  @doc """
  Add one or many attributes to an event

  If you post a raw JSON array, phoenix will cast to to the _json parameter
  """
  def add_attribute(conn, params, opts \\ [])

  def add_attribute(conn, %{"id" => event_id, "_json" => params}, opts)
      when is_list(params) do

    with %User{} = user <- Utils.get_user(conn),
         {:query, %Event{} = event} <- {:query, Repo.get(Event, event_id)},
         {event_id, ""} <- Integer.parse(event_id),
         {:permissions, true} <- {:permissions, user |> can? edit(event)} do
      params
      |> Stream.map(&Attribute.changeset(%Attribute{event_id: event_id}, &1))
      |> Enum.split_with(fn %Ecto.Changeset{} = changeset -> changeset.valid? end)
      |> case do
        {valid_attributes, []} ->
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
          |> case do
            {:ok, transaction} ->
              conn
              |> put_status(201)
              |> json(
                AttributeView.render(
                  Keyword.get(opts, :as, "attributes.json"),
                  %{attributes: Map.values(transaction)}
                )
              )

            {:error, _, changeset, _} ->
              ErrorStatus.validation_error(conn, changeset)

            out ->
              IO.inspect(out)
          end

        {_, invalid_attributes} ->
          ErrorStatus.validation_error(conn, invalid_attributes)
      end
    else
      {:query, nil} -> ErrorStatus.not_found(conn, "Event #{event_id} not found")
      {:permissions, false} -> ErrorStatus.not_allowed(conn)
    end
  end

  def add_attribute(conn, %{"id" => event_id} = params, opts) do
    # In the case that we get a single object,
    # We don't want to just return an array by using our other function,
    # we want to return the created object. Luckily this is quite easy.
    with %User{} = user <- Utils.get_user(conn),
         {:query, %Event{} = event} <- {:query, Repo.get(Event, event_id)},
         {:permissions, true} <- {:permissions, user |> can? edit(event)} do
      changeset = Attribute.changeset(%Attribute{}, params)

      if changeset.valid? do
        case Repo.insert(changeset) do
          {:ok, attribute} ->
            conn
            |> put_status(201)
            |> json(
              AttributeView.render(Keyword.get(opts, :as, "attribute.json"), %{
                attribute: attribute
              })
            )

          {:error, changeset} ->
            ErrorStatus.validation_error(conn, changeset)
        end
      else
        ErrorStatus.validation_error(conn, changeset)
      end
    else
      {:query, nil} -> ErrorStatus.not_found(conn, "Event #{event_id} not found")
      {:permissions, false} -> ErrorStatus.not_allowed(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    with %User{} = user <- Utils.get_user(conn),
         {:query, %Event{} = event} <- {:query, Repo.get(Event, id)},
         {:permissions, true} <- {:permissions, user |> can? delete(event)},
         {:delete, {:ok, _}} <- {:delete, Repo.delete(event)} do
      json(conn, %{deleted: true})
    else
      {:query, nil} -> ErrorStatus.not_found(conn, "Event #{id} not found")
      {:permissions, false} -> ErrorStatus.not_allowed(conn)
      {:delete, _} -> ErrorStatus.internal_error(conn, "Error deleting event")
    end
  end

  def search(conn, params) do
    {entries, page_count} = Event.Search.run(params)

    conn
    |> put_resp_header("x-page-count", to_string(page_count))
    |> json(EventView.render("events.json", %{events: entries}))
  end

  def get_attributes(conn, %{"id" => id}, opts \\ [as: "attributes.json"]) do
    attributes = Repo.all(from attribute in Attribute, where: attribute.event_id == ^id)

    conn
    |> json(AttributeView.render(opts[:as], %{attributes: attributes}))
  end

  def get_tags(conn, %{"id" => id}) do
    with %Event{} = event <- Event.get_with_preload(id, [:tags]) do
      conn
      |> json(TagView.render("tags.json", %{tags: event.tags}))
    end
  end

  def add_tag(conn, %{"event_id" => id, "_json" => params}) do
    # Add multiple tags
    with %User{} = user <- Utils.get_user(conn),
         {:query, %Event{} = event} <- {:query, Event.get_with_preload(id, [:tags])},
         {:permissions, true} <- {:permissions, user |> can? tag(event)} do

      changeset = Event.add_tags_changeset(event, %{tags: params})

      if changeset.valid? do
        {:ok, event} = Repo.update(changeset)

        conn
        |> put_status(201)
        |> json(TagView.render("tags.json", %{tags: event.tags}))
      else
        ErrorStatus.validation_error(conn, changeset)
      end
    else
      {:query, nil} -> ErrorStatus.not_found(conn, "Event #{id} not found")
      {:permissions, false} -> ErrorStatus.not_allowed(conn)
    end
  end

  def add_tag(conn, %{"event_id" => id} = params) do
    # One tag only
    with %User{} = user <- Utils.get_user(conn),
         {:query, %Event{} = event} <- {:query, Event.get_with_preload(id, [:tags])},
         {:permissions, true} <- {:permissions, user |> can? tag(event)} do
      changeset = Event.add_tags_changeset(event, %{tags: [params]})

      if changeset.valid? do
        {:ok, event} = Repo.update(changeset)

        conn
        |> put_status(201)
        |> json(TagView.render("tag.json", %{tag: List.last(event.tags)}))
      else
        ErrorStatus.validation_error(conn, changeset)
      end
    else
      {:query, nil} -> ErrorStatus.not_found(conn, "Event #{id} not found")
      {:permissions, false} -> ErrorStatus.not_allowed(conn)
    end
  end
end
