defmodule Koueki.Sync.MISP do
  @moduledoc """
  The adapter to enable syncing with MISP servers. Uses legacy APIs.
  """

  use Task
  import Koueki.Tasks.Sync.Common
  import Ecto.Query
  require Logger

  alias Koueki.{
    Server,
    Event,
    Repo,
    Org,
    HTTPAdapters
  }

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(arg) do
    with %Server{} = server <- Repo.get(Server, arg) do
      sync_url =
        server.url
        |> URI.merge("/events/restSearch")
        |> URI.to_string()

      last_sync = DateTime.to_unix(server.last_sync)
      # Give a minute's leeway just in case
      seconds_since_last = DateTime.to_unix(DateTime.utc_now()) - last_sync + 60

      {:ok, post_body} =
        %{last: "#{seconds_since_last}s"}
        |> Jason.encode()

      resp = HTTPAdapters.MISP.request(:post, server, sync_url, post_body)
      case resp do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body} = Jason.decode(body)

          body
          |> Map.get("response")
          |> Enum.map(fn event_json ->
            # DATA RESOLUTION - Pretty awkward
            event_json =
              event_json
              |> Map.get("Event")

            # First, get our local event, or a new struct if we don't have one
            local_event = Repo.one(from event in Event,
              where: event.uuid == ^event_json["uuid"],
              preload: [:org, :tags, attributes: :tags]
            )

            remote_event_params = 
              event_json
              |> Event.normalise_from_misp()
              |> Event.resolve_inbound_attributes(local_event)

            with %Event{} <- local_event do
              # Event exists in our DB, udpdate it accordingly
              {:ok, event} = 
                local_event
                |> Event.changeset(remote_event_params)
                |> Repo.update()
            else
              nil ->
              {:ok, event} =
                %Event{}
                |> Event.changeset(remote_event_params)
                |> Repo.insert()
            end
          end)

          time = DateTime.utc_now()
          changeset = Server.changeset(server, %{last_sync: time})
          {:ok, _} = Repo.update(changeset)

        {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
          Logger.error("Server #{server.id} returned status #{code}")
          Logger.error(body)

        {:error, reason} ->
          Logger.error("HTTP Error on sync")
          IO.inspect(reason)
      end
    end
  end
end
