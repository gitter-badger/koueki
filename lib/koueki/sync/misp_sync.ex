defmodule Koueki.Sync.MISP do
  @moduledoc """
  The adapter to enable syncing with MISP servers. Uses legacy APIs.
  """

  use Task
  import Koueki.Tasks.Sync.Common
  require Logger

  alias Koueki.{
    Server,
    Event,
    Repo,
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
      seconds_since_last = DateTime.to_unix(DateTime.utc_now()) - last_sync

      {:ok, post_body} =
        %{last: "#{seconds_since_last}s"}
        |> Jason.encode()

      IO.puts post_body

      resp = HTTPAdapters.MISP.request(:post, server, sync_url, post_body)

      case resp do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body} = Jason.decode(body)

          body
          |> Map.get("response")
          |> Enum.map(fn event ->
            event
            |> Map.get("Event")
            |> Event.normalise_from_misp()
            |> Map.put("org_id", server.org_id)
            |> Event.find_or_create()
            |> Repo.insert_or_update()
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
